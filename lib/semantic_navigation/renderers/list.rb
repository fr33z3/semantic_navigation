module SemanticNavigation
  module Renderers
    class List
      include RenderHelpers
      include ActsAsList
      
      navigation_default_classes [:list]
      
      private
      
      def navigation(object)
        content_tag :ul, nil, :id => show_id(:navigation, object.id),
                              :class => merge_classes(:navigation, object.active, object.classes) do
          yield
        end
      end
      
      def node(object)
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes) do
          link_to(object_name(object), object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active, object.link_classes))+
          yield
        end 
      end
      
      def node_content(object)
        content_tag(:ul, nil, :id => show_id(:node, object.id),
                              :class => merge_classes(:node, object.active, object.node_classes)) do
          yield  
        end
      end
      
      def leaf(object)
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes) do
          link_to object_name(object), object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active, object.link_classes)
        end
      end
      
    end
  end
end
