module SemanticNavigation
  module TwitterBootstrap
    class Tabs
      include SemanticNavigation::Renderers::RenderHelpers
      include SemanticNavigation::Renderers::ActsAsList
      
      navigation_default_classes [:nav, 'nav-tabs']
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
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes).push(:dropdown) do
          content_tag(:a, :href => '#',
                          :id => show_id(:link, object.id),
                          :class => merge_classes(:link, object.active, object.link_classes).push('dropdown-toggle'),
                          'data-toggle'=> :dropdown) do
            [object.ico ? content_tag(:i,nil,:class => "icon-#{object.ico}") : '',
             object.name,
             content_tag(:b,nil,:class => :caret)
            ].sum.html_safe                     
          end +
          yield
        end 
      end
      
      def node_content(object)
        content_tag(:ul, nil, :id => show_id(:node, object.id),
                              :class => merge_classes(:node, false, object.node_classes).push('dropdown-menu')) do
          yield
        end
      end
      
      def leaf(object)
        if object.ico
          name = [content_tag(:i,nil,:class => "icon-#{object.ico}"),
                  object.name].sum
        else
          name = object.name
        end
                
        content_tag :li, nil, :id => show_id(:leaf, object.id),
                              :class => merge_classes(:leaf, object.active, object.classes) do
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
