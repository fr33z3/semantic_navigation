require 'semantic_navigation'

module SemanticNavigation
  class Railtie < Rails::Railtie
    initializer "semantic_navigation.helper_methods" do
      ActionView::Base.send :include, HelperMethods
    end
  end
end
