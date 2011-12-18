require 'semantic_navigation/menu'

module SemanticNavigation
  class Configuration
    
    attr_accessor :active_class, :create_ids, :show_submenu 

    class << self
      def run
        instance = self.new
        yield instance if block_given?
        instance
      end
    end

    def initialize
      @active_class = 'active'
      @create_ids = true
      @show_submenu = false
      @menus = {}
    end
  
    def method_missing(name)
      menu = SemanticNavigation::Menu.new
      @menus.merge!({name.to_sym => menu})
      yield menu if block_given?
    end

    def render(name)
      if @menus[name.to_sym]
        return @menus[name.to_sym].render
      else
        return nil  
      end
    end

  end
end
