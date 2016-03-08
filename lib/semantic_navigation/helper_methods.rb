module SemanticNavigation::HelperMethods

  def navigation_for(navigation_name, options = {})
    render_name = options.delete(:as) || :list
    __configuration__.new.render(navigation_name, render_name, options, self)
  end

  def active_item_for(navigation_name, level = nil, &block)
    __configuration__.view_object = self
    item = __configuration__.navigation_current_item(navigation_name, level)
    if block_given?
      capture(item, &block)
    else
      item.is_root? ? "" : item.name(:active_item_for)
    end
  end

  def active_level_for(navigation_name)
    __configuration__.view_object = self
    __configuration__.navigation_current_level(navigation_name, nil)
  end

  private

  def __configuration__
    SemanticNavigation::Configuration
  end

end
