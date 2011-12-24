module SemanticNavigation::HelperMethods
  
  def method_missing(name, command = :render)
    name = name.to_s
    if name[0..6] == 'render_'
      SemanticNavigation::Item.set_default_option('view_object',self)
      semantic_navigation_config.render(name[7..-1], command)
    else
      raise NoMethodError.new("NoMethodError:#{name}")
    end
  end

  private
 
  def semantic_navigation_config
    eval(IO.read("#{Rails.root}/config/semantic_navigation.rb"))
  end
 

end
