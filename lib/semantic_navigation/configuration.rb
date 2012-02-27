module SemanticNavigation
  class Configuration
       
    def initialize
      @menus = {}
      @styles = {}
    end
      
    def self.run(&block)
      configuration_instance = self.new
      configuration_instance.instance_eval(&block) if block_given?
      configuration_instance
    end
    
    def navigate(menu_id, options = {}, &block)
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
      
      rendering_menu.send(as)
    end
    
    def styles_for(name,render_name,styles)
      @styles[name] ||= {}
      render_name = [render_name] if render_name.is_a? Symbol
      render_name.each do |r|
        @styles[name][r] ||= default_styles
        @styles[name][r].merge! styles
      end
    end
    
    def register_renderer(renderer_class)
      
    end
  
  end
end
