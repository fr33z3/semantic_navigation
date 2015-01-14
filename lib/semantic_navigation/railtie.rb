require 'semantic_navigation/helper_methods'

module SemanticNavigation
  class Railtie < Rails::Railtie

    initializer "semantic_navigation.extend_helper_methods" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, HelperMethods
      end

      conf = SemanticNavigation::Configuration
      conf.register_renderer :list, Renderers::List
      conf.register_renderer :breadcrumb, Renderers::BreadCrumb
    end

    def self.register_bootstrap_renderers
      conf = SemanticNavigation::Configuration
      namespace = conf.bootstrap_version == 2 ? TwitterBootstrap : TwitterBootstrap3
      conf.register_renderer :bootstrap_breadcrumb, namespace::Breadcrumb
      conf.register_renderer :bootstrap_list, namespace::List
      conf.register_renderer :bootstrap_tabs, namespace::Tabs
      conf.register_renderer :bootstrap_pills, namespace::Tabs
      
      conf.register_renderer :bootstrap_simple_nav, SemanticNavigation::Renderers::List

      conf.styles_for :bootstrap_pills do
        navigation_default_classes [:nav, 'nav-pills']
      end
      conf.styles_for :bootstrap_simple_nav do
        navigation_default_classes [:nav]
      end
    end

    if Rails.env == "production"
     config.after_initialize {
       load SemanticNavigation.actual_config_location
       SemanticNavigation::Railtie.register_bootstrap_renderers
     }
    else
     ActionDispatch::Callbacks.to_prepare {
       require 'pry'
       load SemanticNavigation.actual_config_location
       SemanticNavigation::Railtie.register_bootstrap_renderers
     }
    end

  end
end
