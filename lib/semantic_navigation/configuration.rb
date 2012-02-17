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
      options[:menu_id] ||= menu_id.to_s
      @menus[menu_id] = Menu.new options
      @menus[menu_id].instance_eval(&block) if block_given?
    end
    
    def render(menu_id, options)
      as = options.delete :as
      menu = @menus[menu_id]
      options.keys.each do |key|
        menu.send(key, options[key])
      end
      menu.send(as)
    end
    
    def self.view_object=(view_object)
      @@view_object = view_object
    end
    
    def self.view_object
      @@view_object
    end
  end
end
