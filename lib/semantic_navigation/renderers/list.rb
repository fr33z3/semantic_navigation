module SemanticNavigation
  module Renderers
    class List < Base
      
      @@show_navigation_active_class = false
      @@show_node_active_class = false
      @@show_leaf_active_class = false
      
      @@show_link_id = false
      
      def navigation(object)
        content_tag :ul, nil, :id => show_id(:navigation, object.id),
                              :class => merge_classes(:navigation, object.active) do
          yield
        end
      end    
      
      def node(object)
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active) do
          link_to(object.name, object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active))+
          content_tag(:ul, nil, :id => show_id(:node, object.id),
                                :class => merge_classes(:node, object.active)) do
            yield
          end
        end 
      end
      
      def leaf(object)
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active) do
          link_to object.name, object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active)
        end
      end
      
    end
  end
end
