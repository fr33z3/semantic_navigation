module SemanticNavigation::HelperMethods

  def navigation_for(name, options = {})
    render_name = options.delete :as
    render_name ||= :list
    SemanticNavigation::Configuration.new.render(name, render_name, options, self)
  end
  
  private

end
