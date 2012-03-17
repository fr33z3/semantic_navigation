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
      id = id.to_sym
      options[:id] = id
      i18n_hash = I18n.t(:semantic_navigation)
      if i18n_hash.is_a? Hash
        options[:i18n_hash] = i18n_hash[id]
      end
      navigation = Core::Navigation.new(options)
      navigation.instance_eval &block if block_given?
      @@navigations[id.to_sym] = navigation
    end
    
    def render(menu_id, renderer_name, options, view_object)
      renderer = @@renderers[renderer_name].new(view_object)
      @@navigations[menu_id].render(renderer)
    end
    
    def self.styles_for(name,render_name,styles)
    
    end
    
    def self.register_renderer(renderer_class)
      
    end
  
  end
end
