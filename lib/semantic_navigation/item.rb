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
      link = view_object.link_to @name, @url_options
      view_object.content_tag(:li, link + sub_render(view_object), :id => @item_id)
    end
    
    private
    
    def sub_render(view_object)
      if @sub_items.count > 0
        sub = @sub_items.map{|s| s.render(view_object)}.sum
        view_object.content_tag(:ul, sub)
      end
    end
    
  end
end
