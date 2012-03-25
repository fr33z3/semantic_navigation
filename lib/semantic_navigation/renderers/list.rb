module SemanticNavigation
  module Renderers
    class List
      include RenderHelpers
      
      style_accessor :navigation_active_class => [:active],
                     :node_active_class => [:active],
                     :leaf_active_class => [:active],
                     :link_active_class => [:active],
      
                     :show_navigation_active_class => true,
                     :show_node_active_class => true,
                     :show_leaf_active_class => true,
                     :show_link_active_class => true,
      
                     :show_navigation_id => true,
                     :show_node_id => true,
                     :show_leaf_id => true,
                     :show_link_id => true,
      
                     :navigation_default_classes => [], 
                     :node_default_classes => [],
                     :leaf_default_classes => [],
                     :link_default_classes => []      
       
      def render_navigation(object)
        navigation(object) do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end
      
      def render_node(object)
        node(object) do
          object.sub_elements.sum{|element| element.render(self)}
        end
      end
      
      def render_leaf(object)
        leaf(object)
      end
      
      private
      
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
