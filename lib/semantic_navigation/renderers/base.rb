module SemanticNavigation
  module Renderers
    class Base
    
      attr_accessor :from_level, :until_level
      
      @@navigation_active_class = 'active'
      @@node_active_class = 'active'
      @@leaf_active_class = 'active'
      @@link_active_class = 'active'
      
      def initialize(view_object)
        @view_object = view_object
      end
      
      def render_navigation(object)
        object.mark_active(@view_object)
      end
      
      private
      
      def content_tag(tag_name, content = nil, options = {}, &block)
        @view_object.content_tag(tag_name, content, options) {yield}
      end
      
      def link_to(link_name, url, options = {})
        @view_object.link_to(link_name, url, options)
      end
      
      def navigation_classes(active = false)
        
      end
      
      def node_classes(active = false)
        
      end
      
      def leaf_classes(active = false)
        
      end
      
      def link_classes(active = false)
        classes = []
        classes.push(@@link_active_class) if active
      end
   
    end    
  end
end
