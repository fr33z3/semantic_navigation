module SemanticNavigation
  module Renderers
  	module ActsAsBreadcrumb
  	  
  	  def self.included(base)
        SemanticNavigation.deprecation_message(:module,
                          "SemanticNavigation::Renderers::ActsAsBreadcrumb",
                          "SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb")
        base.send :include, SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb
  	  end

  	end
  end
end