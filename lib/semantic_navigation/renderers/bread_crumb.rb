module SemanticNavigation
  module Renderers
    class BreadCrumb
      include RenderHelpers
      include ActsAsBreadcrumb

      style_accessor :last_as_link => false
      
      navigation_default_classes [:breadcrumb]
      
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
          link_to(object.name, object.url, :id => show_id(:link, object.id),
                                           :class => merge_classes(:link, object.active, object.link_classes))+
          yield
        end 
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
