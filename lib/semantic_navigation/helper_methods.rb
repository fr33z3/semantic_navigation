module SemanticNavigation::HelperMethods
  
  def method_missing(name, options = {})
    name = name.to_s
    if name[0..6] == 'render_'
      semantic_navigation_config.render(name[7..-1].to_sym, options)
    else
      raise NoMethodError.new("NoMethodError:#{name}")
    end
  end

  private
 
  def semantic_navigation_config
    eval(IO.read("#{Rails.root}/config/semantic_navigation.rb"))
  end
 

end
