module SemanticNavigation
  module TwitterBootstrap
    class Breadcrumb
      include SemanticNavigation::Renderers::RenderHelpers
      include SemanticNavigation::Renderers::ActsAsBreadcrumb

      style_accessor last_as_link: false,
                     breadcrumb_separator: '/'

      navigation_default_classes [:breadcrumb]

      show_navigation_active_class false
      show_node_active_class false
      show_leaf_active_class false
      show_link_active_class false
      show_navigation_id false
      show_node_id false
      show_leaf_id false
      show_link_id false

      property_for :base, :ico

      private

      def navigation(object)
        content_tag :ul, nil, {id: show_id(:navigation, object.id),
                               class: merge_classes(:navigation, object.active, object.classes)
                              }.merge(object.html) do
          yield
        end
      end

      def node(object)
        content_tag(:li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, object.classes)
                              }.merge(object.html)) do
          [object.ico ? content_tag(:i, nil, class: "icon-#{object.ico}") : ''.html_safe,
          link_to(object_name(object),
                  object.url, 
                  {id: show_id(:link, object.id),
                   class: merge_classes(:link, object.active, object.link_classes)
                  }.merge(object.link_html)),
          content_tag(:span, nil, class: [:divider]) {breadcrumb_separator}].sum
        end +
        yield
      end

      def leaf(object)
        content_tag :li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, object.classes)
                              }.merge(object.html) do
          [object.ico ? content_tag(:i, nil, class: "icon-#{object.ico}") : ''.html_safe,
          if last_as_link
            link_to(object_name(object), 
                    object.url, 
                    {id: show_id(:link, object.id),
                     class: merge_classes(:link, object.active, object.link_classes)
                    }.merge(object.link_html))
          else
            object_name(object)
          end].sum
        end
      end

    end
  end
end
