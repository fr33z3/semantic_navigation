module SemanticNavigation
  class Item
 
    def initialize(id, args, parent)
      @item_id = id
      @name = args.first
      @url_options = args.second
      @parent = parent
      
      @sub_items = []
      @active_class = 'active'
      @active = false
    end

    def method_missing(name, *args)
      item = SemanticNavigation::Item.new(name.to_s, args, self)
      @sub_items << item
      yield item if block_given?
    end

    def render(view_object)
      @view_object = view_object
      if parent
        set_as_active if active?
        sub = render_subitems
        link = view_object.link_to @name, @url_options, :class => classes, :id => @item_id
        view_object.content_tag(:li, link + sub, :id => @item_id, :class => classes)
      else
        render_subitems
      end  
    end

    def set_as_active
      @active = true
      parent.set_as_active if parent
    end
    
    private
    
    def render_subitems
      if @sub_items.count > 0
        sub = @sub_items.map{|s| s.render(@view_object)}.sum
        @view_object.content_tag(:ul, sub, :id => @item_id)
      end
    end
    
    def classes
      if @active
        @active_class
      end
    end
    
    def active?
      @view_object.current_page?(@url_options)
    end
    
    def parent
      @parent.is_a?(SemanticNavigation::Item) ? @parent : nil
    end
    
  end
end
