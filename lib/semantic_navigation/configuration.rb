require 'semantic_navigation/core'
require 'semantic_navigation/renderers'

module SemanticNavigation
  class Configuration
    
    @@navigations = {}
    @@renderers = {:list => Renderers::List}
      
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
      options.keys.each{|key| renderer.send "#{key}=", options[key]}
      navigation = @@navigations[menu_id]
      navigation.mark_active(view_object)
      navigation.render(renderer)
    end
    
    def self.styles_for(name,render_name,styles)
    
    end
    
    def self.register_renderer(renderer_class)
      
    end
  
  end
end
