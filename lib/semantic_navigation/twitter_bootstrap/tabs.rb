module SemanticNavigation
  module TwitterBootstrap
    class Tabs
      include SemanticNavigation::Renderers::MixIn::RenderHelpers
      include SemanticNavigation::Renderers::MixIn::ActsAsList

      style_accessor direction: 'left'

      navigation_default_classes [:nav, 'nav-tabs']
      show_navigation_id false
      show_node_id false
      show_leaf_id false
      show_link_id false

      property_for :base, :ico

      private

      def navigation(object)
        content_tag :ul, nil, {id: show_id(:navigation, object.id),
                               class: merge_classes(:navigation, object.active, [object.classes,"pull-#{direction}"])
                              }.merge(object.html) do
          yield
        end
      end

      def node(object)
        content_tag :li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, [object.classes,'dropdown'].flatten)
                              }.merge(object.html) do
          content_tag(:a, {:href => '#',
                           id: show_id(:link, object.id),
                           class: merge_classes(:link, object.active, [object.link_classes,'dropdown-toggle'].flatten),
                           'data-toggle'=> :dropdown
                           }.merge(object.link_html)) do
            [object.ico ? content_tag(:i,nil,class: "icon-#{object.ico}") : '',
             object_name(object),
             content_tag(:b,nil,class: :caret)
            ].sum.html_safe
          end +
          yield
        end
      end

      def node_content(object)
        content_tag(:ul, nil, {id: show_id(:node, object.id),
                               class: merge_classes(:node, false, [object.node_classes,'dropdown-menu'].flatten)
                              }.merge(object.node_html)) do
          yield
        end
      end

      def leaf(object)
        if object.ico
          name = [content_tag(:i,nil,class: "icon-#{object.ico}"),
                  object_name(object)].sum
        else
          name = object_name(object)
        end

        content_tag :li, nil, {id: show_id(:leaf, object.id),
                              class: merge_classes(:leaf, object.active, object.classes)
                              }.merge(object.html) do
          if object.url.nil?
            name
          else
            link_to name, object.url, {id: show_id(:link, object.id),
                                      class: merge_classes(:link, object.active, object.link_classes)
                                      }.merge(object.link_html)
          end
        end
      end

    end
  end
end
