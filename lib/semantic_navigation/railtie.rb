require 'semantic_navigation/helper_methods'

module SemanticNavigation
  class Railtie < Rails::Railtie
   
    initializer "semantic_navigation.extend_helper_methods" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, HelperMethods
      end
    end
    
    if Rails.env == "production"
      config.after_initialize {
        load "#{Rails.root}/config/semantic_navigation.rb"
      }
    else
      ActionDispatch::Callbacks.before {
        load "#{Rails.root}/config/semantic_navigation.rb"
      }      
    end
    
  end
end
