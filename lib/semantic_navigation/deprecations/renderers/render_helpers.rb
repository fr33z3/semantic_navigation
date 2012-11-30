module SemanticNavigation
  module Renderers
  	module RenderHelpers
      
      def self.included(base)
        SemanticNavigation.deprecation_message(:module,
                          "SemanticNavigation::Renderers::RenderHelpers",
                          "SemanticNavigation::Renderers::MixIn::RenderHelpers")        
        base.send :include, SemanticNavigation::Renderers::MixIn::RenderHelpers
      end

  	end
  end
end