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

    def render(view_object)
      s = @items.map{|i| i.render(view_object)}.join
      "<ul>\n#{s}\n</ul>".html_safe
    end
    
  end
end
