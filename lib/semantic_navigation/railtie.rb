require 'semantic_navigation/helper_methods'

module SemanticNavigation
  class Railtie < Rails::Railtie
    BOOSTSTRAP_NAMESPACES = {
      2 => TwitterBootstrap,
      3 => TwitterBootstrap3
    }

    BOOTSTRAP_RENDERERS = [
      bootsrap_breadcrumb: "Breadcrumb",
      bootstrap_list: "List",
      bootstrap_tabs: "Tabs",
      bootstrap_pills: "Tabs",
    ]

    initializer "semantic_navigation.extend_helper_methods" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, HelperMethods
      end
    end

    def self.register_simple_renderers
      config.register_renderer :list, Renderers::List
      config.register_renderer :breadcrumb, Renderers::BreadCrumb
    end

    def self.register_bootstrap_renderers
      setup_bootstrap_renderers
      config.register_renderer :bootstrap_simple_nav, SemanticNavigation::Renderers::List

      setup_bootstrap_styles
    end

    def self.bootstrap_renderer_class(bootstrap_version, renderer_name)
      namespace = BOOSTSTRAP_NAMESPACES[bootstrap_version]
      class_name = BOOTSTRAP_RENDERERS[renderer_name.to_sym]
      "#{namespace}::#{class_name}".constantize
    end

    def self.setup_bootstrap_renderers
      bootstrap_version = config.bootstrap_version
      BOOTSTRAP_RENDERERS.keys.each do |renderer_name|
        renderer_class = bootstrap_renderer_class(bootstrap_version, renderer_name)
        config.register_renderer(key, renderer_class)
      end
    end

    def self.setup_bootstrap_styles
      config.styles_for :bootstrap_pills do
        navigation_default_classes [:nav, 'nav-pills']
      end
      config.styles_for :bootstrap_simple_nav do
        navigation_default_classes [:nav]
      end
    end

    def config
      SemanticNavigation::Configuration
    end

    if Rails.env == "production"
     config.after_initialize {
       SemanticNavigation::Railtie.register_bootstrap_renderers
       load SemanticNavigation.actual_config_location
     }
    else
     ActionDispatch::Callbacks.to_prepare {
       SemanticNavigation::Railtie.register_bootstrap_renderers
       load SemanticNavigation.actual_config_location
     }
    end

  end
end
