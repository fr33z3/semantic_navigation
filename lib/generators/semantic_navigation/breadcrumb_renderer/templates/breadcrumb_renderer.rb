class Renderers::<%= class_name %>
  #Default render helpers. Do not delete this if don't want to write your own.
  include SemanticNavigation::Renderers::MixIn::RenderHelpers
  #The default list rendering logic. Do not delete if don't want to write your own.
  include SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb
  style_accessor :last_as_link => false,
                 :breadcrumb_separator => '/'

  #Default navigation classes
  navigation_active_class [:active]
  node_active_class [:active]
  leaf_active_class [:active]
  link_active_class [:active]

  show_navigation_active_class true
  show_node_active_class true
  show_leaf_active_class true
  show_link_active_class true

  show_navigation_id true
  show_node_id true
  show_leaf_id true
  show_link_id true

  navigation_default_classes ['<%= file_name %>']
  node_default_classes ['<%= file_name %>']
  leaf_default_classes ['<%= file_name %>']
  link_default_classes ['<%= file_name %>']

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
      link_to(object_name(object), object.url, :id => show_id(:link, object.id),
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
        link_to object_name(object), object.url, :id => show_id(:link, object.id),
                                       :class => merge_classes(:link, object.active, object.link_classes)
      else
        object_name(object)
      end
    end
  end
end
