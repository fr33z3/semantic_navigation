require 'semantic_navigation/item_block'
require 'semantic_navigation/core/default_styles'

module SemanticNavigation
  class Configuration
    include SemanticNavigation::Core::DefaultStyles
       
    def initialize
      @menus = {} 
      @styles = {}
    end
    
    def self.run(&block)
      configuration_instance = self.new
      configuration_instance.instance_eval(&block)
      configuration_instance
    end
    
    def method_missing(menu_id, options = {}, &block)
      options[:item_block_id] ||= menu_id.to_s
      @menus[menu_id] = ItemBlock.new options
      @menus[menu_id].instance_eval(&block) if block_given?
    end
    
    def render(menu_id, options)
      as = options.delete :as
      rendering_menu = @menus[menu_id]
      options.keys.each do |key|
        rendering_menu = rendering_menu.send(key, options[key])
      end
      
      if !@styles[menu_id].nil? && !@styles[menu_id][as].nil?
        @@current_style = @styles[menu_id][as]
      else
        @@current_style = self.send("#{as.to_s}_default_styles")
      end
      
      rendering_menu.send(as)
    end
    
    def styles_for(name,render_name,styles)
      @styles[name] ||= {}
      render_name = [render_name] if render_name.is_a? Symbol
      render_name.each do |r|
        @styles[name][r] ||= self.send("#{r.to_s}_default_styles")
        @styles[name][r].merge! styles
      end
    end
    
    def self.view_object=(view_object)
      @@view_object = view_object
    end
    
    def self.view_object
      @@view_object
    end
    
    def self.current_style
      @@current_style
    end
  
  end
end
