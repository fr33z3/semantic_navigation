module SemanticNavigation
  module Renderers
  	module ActsAsList
  	  def self.included(base)
        SemanticNavigation.deprecation_message(:module,
                          "SemanticNavigation::Renderers::ActsAsList",
                          "SemanticNavigation::Renderers::MixIn::ActsAsList")  	  	
        base.send :include, SemanticNavigation::Renderers::MixIn::ActsAsList  	
  	  end
  	end
  end
end