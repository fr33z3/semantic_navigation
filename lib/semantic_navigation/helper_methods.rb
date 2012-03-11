module SemanticNavigation::HelperMethods

  def navigation_for(name, options = {})
    SemanticNavigation::Configuration.new.render(name, :list, options, self)
  end
  
  private

end
