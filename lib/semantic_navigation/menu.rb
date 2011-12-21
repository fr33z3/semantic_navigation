require 'semantic_navigation/item'

module SemanticNavigation
  class Menu

    def initialize(id)
      @menu_id = id
      @items = []
    end

    def method_missing(name, *args)
      item = SemanticNavigation::Item.new(name.to_s, args, nil)
      @items << item
      yield item if block_given?
    end

    def render(view_object)
      s = @items.map{|i| i.render(view_object)}.sum
      view_object.content_tag(:ul, s, :id => @menu_id)
    end
  end
end
