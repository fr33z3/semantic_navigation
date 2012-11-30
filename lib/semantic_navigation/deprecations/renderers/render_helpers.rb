module SemanticNavigation
  module Renderers
  	module RenderHelpers
      
      def self.included(base)
        puts ['DEPRECATION WARNING: You are using the deprecated namespace for module',
            '`SemanticNavigation::Renderers::RenderHelpers`. ',
            'Please use the new namespace `SemanticNavigation::Renderers::MixIn::RenderHelpers`'
             ].join
        base.send :include, SemanticNavigation::Renderers::MixIn::RenderHelpers
      end

  	end
  end
end