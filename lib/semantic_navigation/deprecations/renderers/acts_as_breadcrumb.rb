module SemanticNavigation
  module Renderers
  	module ActsAsBreadcrumb
  	  
  	  def self.included(base)
        puts ['DEPRECATION WARNING: You are using the deprecated namespace for module',
            '`SemanticNavigation::Renderers::ActsAsBreadcrumb`. ',
            'Please use the new namespace `SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb`'
             ].join
        base.send :include, SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb
  	  end

  	end
  end
end