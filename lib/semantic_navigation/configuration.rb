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

    def render(name, command = :render)
      if @menus[name.to_sym]
        if command == :render
          return @menus[name.to_sym].render
        elsif command == :active_item_name
          item = @menus[name.to_sym].find_active_item
          !item.nil? ? item.name : ''
        elsif command == :active_item_parent_name
          item = @menus[name.to_sym].find_active_item
          !item.nil? && !item.parent.nil? ? item.parent.name : ''
        elsif command == :breadcrumb
          return @menus[name.to_sym].render_breadcrumb
        else
          raise NoMethodError.new("Wrong menu render parameter:`#{command.to_s}`")
        end
      else
        raise NoMethodError.new("No such menu name:`#{name}` check your #{Rails.root}/config/semantic_navigation.rb) file")
      end
    end

  end
end
