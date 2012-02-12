require 'semantic_navigation/menu'

module SemanticNavigation
  class Configuration
        
    def initialize
      @menus = {}  
    end
    
    def self.run(&block)
      configuration_instance = self.new
      configuration_instance.instance_eval(&block)
      configuration_instance
    end
    
    def method_missing(menu_id, options = {}, &block)
      options[:menu_id] = menu_id.to_s
      @menus[menu_id] = Menu.new options
      @menus[menu_id].instance_eval(&block) if block_given?
    end
    
    def render(menu_id, options)
      options[:as] = :menu if options[:as].nil?
      @menus[menu_id].send(options[:as], options)
    end
    
  end
end
