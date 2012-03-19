module SemanticNavigation
  module Renderers
    class List < Base
      
      @@show_navigation_active_class = false
      @@show_node_active_class = false
      @@show_leaf_active_class = false
      
      @@show_link_id = false
      
      def render_navigation(object)
        super
        tag :ul, object do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end    
      
      def render_node(object)
        tag :li, object do
          link(object) + 
          tag(:ul, object) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end 
      end
      
      def render_leaf(object)
        tag :li, object do
          link object
        end
      end
      
    end
  end
end
