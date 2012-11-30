module SemanticNavigation
  module Renderers
  	module ActsAsList
  	  def self.included(base)
        puts ['DEPRECATION WARNING: You are using the deprecated namespace for module',
            '`SemanticNavigation::Renderers::ActsAsList`. ',
            'Please use the new namespace `SemanticNavigation::Renderers::MixIn::ActsAsList`'
             ].join
        base.send :include, SemanticNavigation::Renderers::MixIn::ActsAsList  	
  	  end
  	end
  end
end