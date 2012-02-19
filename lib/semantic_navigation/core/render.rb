module SemanticNavigation
  module Core
    module Render
      
      module ItemRender
        def menu
          sub_menu = !@sub_menu.nil? ? @sub_menu.menu : ''
          unless @item_disabled
            item_text = link_to(@name, @url) + sub_menu
          else
            item_text = @name.html_safe + sub_menu
          end
          #todo: change to real_active class
          if @active
            @item_classes ||= []
            @item_classes.push('active') if @active
          end
          content_tag :li, item_text, :id => @item_id, :class => @item_classes
        end 
      end
  
      module MenuRender
        
        def levels(range)
          from_menu = self
          if range.is_a? Fixnum
            from_menu.until_level(range)
            from_menu = from_menu.from_level(range)
          elsif range.is_a?(Range) || range.is_a?(Array)
            from_menu.until_level(range.last)
            from_menu = from_menu.from_level(range.first)
          end
          from_menu
        end
        
        def from_level(level)
          from_menu = self
          if level > 0
            next_item = @items.find{|item| item.active && !item.sub_menu.nil?} || @items.first
            from_menu = next_item.sub_menu.from_level(level-1) unless next_item.nil? && next_item.sub_menu.nil?
          end
          from_menu
        end
        
        def until_level(level)
          @items.each do |item|
            if level > 0
              item.sub_menu.until_level(level-1) unless item.sub_menu.nil?
            else
              item.sub_menu = nil
            end
          end
          self
        end
        
        def from_menu(name)
          return self if name.to_s == @menu_id
          from_menu = nil
          @items.each do |item|
            from_menu ||= item.sub_menu.from_menu(name)
          end
          from_menu
        end
        
        #renderers
        def active_item_name
          item = @items.find{|item| item.active}
          item.name unless item.nil?
        end
        
        def menu
          content_tag :ul, 
                      @items.count > 0 ? @items.map{|item| item.menu}.sum : '', 
                      :id => @menu_id,
                      :class => @menu_classes
        end 
      end
      
    end  
  end
end