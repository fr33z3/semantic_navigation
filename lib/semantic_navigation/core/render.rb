module SemanticNavigation
  module Core
    module Render
      
      module ItemRender
        def menu
          sub_menu = !@sub_menu.nil? ? @sub_menu.menu : ''
          if !@url.nil?
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
        
        def from_level(level)
          from_menu = self
          
          from_menu
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