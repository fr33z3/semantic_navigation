module SemanticNavigation
  class Item

    def initialize(id, *args)
      @id = id
      @name = args.first
      @sub_items = {}
    end

    def method_missing(name, *args)
      #def method_missing(name)
      #item = SemanticNavigation::Menu.new
      #@menus.merge!({name.to_sym => menu})
      #yield menu if block_given?
    end

    def render
      "<li>#{@name}<li>"
    end
    
  end
end
