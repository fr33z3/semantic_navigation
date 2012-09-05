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

    def self.actual_config_location
      locations =  ["#{Rails.root}/config/initializers/semantic_navigation.rb", 
                    "#{Rails.root}/config/semantic_navigation.rb"]
      actual_location = locations.find{|l| File.exists?(l)}
      throw "Please create a semantic_navigation configuration file before starting the project!" unless actual_location
      puts "DEPRECATION WARNING: Please move the configuration file from #{locations.second} 
            to #{locations.first}! Current configuration file path will be deprecated soon!" if locations.find_index(actual_location) == 1
      actual_location
    end
   
    if Rails.env == "production"
      config.after_initialize {
        load SemanticNavigation::Railtie.actual_config_location
      }
    else
      ActionDispatch::Callbacks.before {
        load SemanticNavigation::Railtie.actual_config_location
      }
    end

  end
end
