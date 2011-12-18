require 'semantic_navigation/item'

module SemanticNavigation
  class Menu

    def initialize
      @items = []
    end

    def method_missing(name, *args)
      item = SemanticNavigation::Item.new(name.to_s, args)
      @items << item
      yield item if block_given?
    end

    def render
      s = @items.map{|i| i.render}.join('/n')
      "<ul>#{s}</ul>"
    end
    
  end
end
