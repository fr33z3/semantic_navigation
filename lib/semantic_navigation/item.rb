module SemanticNavigation
  class Item
 
    def initialize(id, args)
      @item_id = id
      @name = args.first
      @url_options = args.second
      @sub_items = []
    end

    def method_missing(name, *args)
      item = SemanticNavigation::Item.new(name.to_s, args)
      @sub_items << item
      yield item if block_given?
    end

    def render(view_object)
      url = view_object.url_for @url_options
      ["<li id='#{@item_id}'>",
        "<a href = '#{url}'>",
          "#{@name}",
        "</a>",
        sub_render(view_object),
      "</li>"].join("\n")
    end
    
    private
    
    def sub_render(view_object)
      if @sub_items.count > 0
        ["<ul>",
         @sub_items.map{|s| s.render(view_object)}.join("\n"),
         "</ul>"].join("\n")
      end
    end
    
  end
end
