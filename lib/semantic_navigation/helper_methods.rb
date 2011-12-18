module SemanticNavigation::HelperMethods
  
  def method_missing(name)
    name_parts = name.to_s.split('_')
    if (name_parts.count == 3 && name_parts[0] == 'render' && name_parts[2] == 'menu')
      semantic_navigation_config.render(name_parts[1])
    else
      super
    end
  end

  private
 
  def semantic_navigation_config
    eval(IO.read("#{Rails.root}/config/semantic_navigation.rb"))
  end
 

end
