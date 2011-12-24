require 'semantic_navigation/item'

module SemanticNavigation
  class Configuration
    
    def self.run
      instance = self.new
      yield instance if block_given?
      instance
    end

    def initialize
      @menus = {}
    end
  
    def method_missing(name, *args)
      name = name.to_s
      if name.chomp('=') != name
        SemanticNavigation::Item.set_default_option(name.chop,args[0])
      else  
        menu = Item.new(name, args, nil)
        @menus.merge!({name.to_sym => menu})
        yield menu if block_given?
      end
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
