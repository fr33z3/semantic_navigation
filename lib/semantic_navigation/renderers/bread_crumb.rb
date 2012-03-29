module SemanticNavigation
  module Renderers
    class BreadCrumb
      include RenderHelpers
      include ActsAsBreadcrumb

      style_accessor :last_as_link => false,
                     :breadcrumb_separator => '/'
      
      navigation_default_classes [:breadcrumb]
      show_navigation_active_class false
      show_node_active_class false
      show_leaf_active_class false
      show_link_active_class false
      
      private
      
      def navigation(object)
        content_tag :ul, nil, :id => show_id(:navigation, object.id),
                              :class => merge_classes(:navigation, object.active, object.classes) do
          yield
        end
      end
      
      def node(object)
        content_tag(:li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes)) do
          link_to(object.name, object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active, object.link_classes))
        end +
        content_tag(:li) do
          breadcrumb_separator
        end +
        yield
      end
     
      def leaf(object)
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes) do
          if last_as_link
            link_to object.name, object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active, object.link_classes)
          else
            object.name
          end
        end
      end
    end
  end
end
