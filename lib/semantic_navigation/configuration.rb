module SemanticNavigation
  class Configuration
    
    @@navigations = {}
    @@renderers = {:list => Renderers::List,
                   :breadcrumb => Renderers::BreadCrumb
                  }
    @@render_styles = {}
        
    def self.run(&block)
      self.class_eval &block if block_given?
    end
    
    def self.navigate(id, options = {}, &block)
      options[:id] = id.to_sym
      options[:i18n_name] = "semantic_navigation.#{id}"
      navigation = Core::Navigation.new(options)
      navigation.instance_eval &block if block_given?
      @@navigations[id.to_sym] = navigation
    end
    
    def render(menu_id, renderer_name, options, view_object)
      renderer = @@renderers[renderer_name].new(view_object)
      unless @@render_styles[renderer_name].nil?
        renderer.instance_eval &@@render_styles[renderer_name]
      end
      options.keys.each{|key| renderer.send "#{key}=", options[key]}
      navigation = @@navigations[menu_id]
      navigation.mark_active(view_object)
      navigation.render(renderer)
    end
    
    def self.styles_for(name)
      @@render_styles[name.to_sym] = proc
    end
    
    def self.to_s
      "<#{self.name}:#{@@navigations};#{@@renderers}>"
    end
    
    def self.register_renderer(*options)
      if options.count == 1
        name = options[0].name.demodulize.underscore.to_sym
        @@renderers[name] = options[0]
      elsif options.count == 2 
        name = options[0].to_sym
        @@renderers[name] = options[1]
      end
    end
  
  end
end
