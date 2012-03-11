require 'semantic_navigation/helper_methods'
require 'rails'

module SemanticNavigation
  class Railtie < Rails::Railtie
    
    initializer "semantic_navigation.helper_methods" do
      ActionView::Base.send :include, HelperMethods
      require "#{Rails.root}/config/semantic_navigation.rb"
    end
 
  end
end
