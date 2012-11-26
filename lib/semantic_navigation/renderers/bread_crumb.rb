module SemanticNavigation
  module Renderers
    class BreadCrumb
      include MixIn::RenderHelpers
      include MixIn::ActsAsBreadcrumb

      style_accessor last_as_link: false,
                     breadcrumb_separator: '/'

      navigation_default_classes [:breadcrumb]
      show_navigation_active_class false
      show_node_active_class false
      show_leaf_active_class false
      show_link_active_class false

      private

      def navigation(object)
        content_menu_tag({id: show_id(:navigation, object.id),
                          class: merge_classes(:navigation, object.active, object.classes)
                         }.merge(object.html)) do
          yield
        end
      end

      def node(object)
        content_tag(:li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, object.classes)
                              }.merge(object.html)) do
          link_to(object_name(object), 
                  object.url, 
                  {id: show_id(:link, object.id),
                   class: merge_classes(:link, object.active, object.link_classes)
                  }.merge(object.link_html))
        end +
        content_tag(:li) do
          breadcrumb_separator
        end +
        yield
      end

      def leaf(object)
        content_tag :li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, object.classes)
                              }.merge(object.html) do
          if last_as_link
            link_to object_name(object), 
                    object.url, 
                    {id: show_id(:link, object.id),
                     class: merge_classes(:link, object.active, object.link_classes)
                    }.merge(object.link_html)
          else
            object_name(object)
          end
        end
      end
    end
  end
end
