module SemanticNavigation
  module TwitterBootstrap
    class List
      include SemanticNavigation::Renderers::RenderHelpers
      include SemanticNavigation::Renderers::ActsAsList

      navigation_default_classes [:nav, 'nav-list']
      show_navigation_id false
      show_node_id false
      show_leaf_id false
      show_link_id false

      property_for :base, :ico

      private

      def navigation(object)
        content_tag :ul, nil, :id => show_id(:navigation, object.id),
                                :class => merge_classes(:navigation, object.active, object.classes) do
          yield
        end
      end

      def node(object)
        if object.ico
          name = [content_tag(:i,nil,:class => "icon-#{object.ico}"),
                  object_name(object)].sum
        else
          name = object_name(object)
        end

        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes) do
           link_to(name, object.url, :id => show_id(:link, object.id),
                                            :class => merge_classes(:link, object.active, object.link_classes)) +
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
        if object_name(object).empty? && object.url.nil?
          classes = 'divider'
        elsif object.url.nil?
          classes = 'nav-header'
        else
          classes = merge_classes(:leaf, object.active, object.classes)
        end

        if object.ico
          name = [content_tag(:i,nil,:class => "icon-#{object.ico}"),
                  object_name(object)].sum
        else
          name = object_name(object)
        end

        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => classes do
          if object.url.nil?
            name
          else
            link_to name, object.url, :id => show_id(:link, object.id),
                                      :class => merge_classes(:link, object.active, object.link_classes)
          end
        end
      end

    end
  end
end
