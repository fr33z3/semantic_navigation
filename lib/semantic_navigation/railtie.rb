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
      conf.register_renderer :bootstrap_breadcrumb, TwitterBootstrap::Breadcrumb
      conf.register_renderer :bootstrap_list, TwitterBootstrap::List
      conf.register_renderer :bootstrap_tabs, TwitterBootstrap::Tabs
      conf.register_renderer :bootstrap_pills, TwitterBootstrap::Tabs
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
        load "#{Rails.root}/config/initializers/semantic_navigation.rb"
      }
    else
      ActionDispatch::Callbacks.before {
        load "#{Rails.root}/config/initializers/semantic_navigation.rb"
      }
    end

  end
end
