module SemanticNavigation
  module Renderers
    class Base
    
      attr_accessor :from_level, :until_level
      
      def initialize(view_object)
        @view_object = view_object
      end
      
      def render_navigation
       
      end
      
      private
      
      def content_tag(tag_name, content = nil, options = {}, &block)
        @view_object.content_tag(tag_name, content, options) {yield}
      end
      
      def link_to(link_name, url, options = {})
        @view_object.link_to(link_name, url, options)
      end
   
    end    
  end
end
