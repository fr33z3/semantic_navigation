module SemanticNavigation
  module Renderers
    class List < Base
      
      def render_navigation(object)
        super
        content_tag :ul, nil, :id => object.id, :class => navigation_classes(object.active) do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end    
      
      def render_node(object)
        content_tag :li, nil, :id => object.id, :class => leaf_classes(object.active) do
          link_to(object.name, object.url, :id => object.id, :class => link_classes(object.active)) + 
          content_tag(:ul, nil, :id => object.id, :class => node_classes(object.active)) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end 
      end
      
      def render_leaf(object)
        content_tag :li, nil, :id => object.id, :class => leaf_classes(object.active) do
          link_to object.name, object.url, :id => object.id, :class => link_classes(object.active)
        end
      end
      
    end
  end
end
