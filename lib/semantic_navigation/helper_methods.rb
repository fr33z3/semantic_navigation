module SemanticNavigation::HelperMethods

  def navigation_for(name, options = {})
    render_name = options.delete :as
    render_name ||= :list
    SemanticNavigation::Configuration.new.render(name, render_name, options, self)
  end

  def active_item_for(name, level = nil)
    SemanticNavigation::Configuration.view_object = self
    navigation = SemanticNavigation::Configuration.navigation(name)
    navigation.mark_active
    item = navigation
    while !item.is_a?(SemanticNavigation::Core::Leaf) &&
          !item.sub_elements.find{|e| e.active}.nil? &&
          (!level.nil? ? item.level < level : true)
      item = item.sub_elements.find{|e| e.active}
    end
    item != navigation ? item.name(:active_item_for) : ''
  end
end
