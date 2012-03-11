module SemanticNavigation
  module Renderers
    class List < Base
      
      def render_navigation(object)
        @view_object.content_tag :ul, nil, :id => object.id do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end    
      
      def render_node(object)
        @view_object.content_tag :li, nil, :id => object.id do
          object.name.html_safe + @view_object.content_tag(:ul, nil, :id => object.id) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end 
      end
      
      def render_leaf(object)
        @view_object.content_tag :li, object.name.html_safe, :id => object.id
      end
      
    end
  end
end
