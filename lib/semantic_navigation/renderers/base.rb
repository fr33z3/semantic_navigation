module SemanticNavigation
  module Renderers
    class Base
    
      attr_accessor :from_level, :until_level
      
      def initialize(view_object)
        @view_object = view_object
      end
      
      def render_navigation
       
      end
   
    end    
  end
end
