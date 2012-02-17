module SemanticNavigation::HelperMethods

  def semantic_render(name, options = {})
    options[:as] ||= :menu
    SemanticNavigation::Configuration.view_object = self
    semantic_navigation_config.render(name.to_sym, options)
  end

  private
 
  def semantic_navigation_config
    eval(IO.read("#{Rails.root}/config/semantic_navigation.rb"))
  end
 

end
