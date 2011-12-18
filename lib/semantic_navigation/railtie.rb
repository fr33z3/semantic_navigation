require 'semantic_navigation/helper_methods'

module SemanticNavigation
  class Railtie < Rails::Railtie
    
    initializer "semantic_navigation.helper_methods" do
      ActionView::Base.send :include, HelperMethods
    end
    
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../tasks/*.rake')].each {|f| load f}
    end
  
  end
end
