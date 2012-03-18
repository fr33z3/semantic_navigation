module SemanticNavigation
  module Renderers
    class List < Base
      
      def render_navigation(object)
        content_tag :ul, nil, :id => object.id do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end    
      
      def render_node(object)
        content_tag :li, nil, :id => object.id do
          link_to(object.name, object.url) + content_tag(:ul, nil, :id => object.id) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end 
      end
      
      def render_leaf(object)
        content_tag :li, nil, :id => object.id do
          link_to object.name, object.url
        end
      end
      
    end
  end
end
