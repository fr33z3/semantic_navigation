module SemanticNavigation
  module TwitterBootstrap3
    class List
      include SemanticNavigation::Renderers::MixIn::RenderHelpers
      include SemanticNavigation::Renderers::MixIn::ActsAsList

      navigation_default_classes [:nav, 'navbar-nav']
      node_default_classes ['dropdown-menu']
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
        if object.ico
          name = [content_tag(:i,nil, class: "icon-#{object.ico}"),
                  object_name(object),
                  content_tag(:span, nil, class: 'caret')].sum
        else
          name = [object_name(object),
                  content_tag(:span, nil, class: 'caret')].sum
        end

        content_tag :li, nil, {id: show_id(:leaf, object.id),
                               class: merge_classes(:leaf, object.active, [*object.classes, 'dropdown'])
                              }.merge(object.html) do
           link_to(name.html_safe, object.url,
              {id: show_id(:link, object.id),
               class: merge_classes(:link, object.active, [*object.link_classes, 'dropdown-toggle']),
               'data-toggle' => 'dropdown'
              }.merge(object.link_html)) +
          yield
        end
      end

      def node_content(object)
        content_tag(:ul, nil, {id: show_id(:node, object.id),
                               class: merge_classes(:node, object.active, object.node_classes)
                              }.merge(object.node_html)) do
          yield
        end
      end

      def leaf(object)
        if object_name(object).empty? && object.url.nil?
          classes = 'divider'
        elsif object.url.nil?
          classes = 'nav-header'
        else
          classes = merge_classes(:leaf, object.active, object.classes)
        end

        if object.ico
          name = [content_tag(:i,nil,class: "icon-#{object.ico}"),
                  object_name(object)].sum
        else
          name = object_name(object)
        end

        content_tag :li, nil, {id: show_id(:leaf, object.id),
                               class: classes
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
