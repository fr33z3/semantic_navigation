module SemanticNavigation
  module Core
    module Render
      
      module ItemRender
        def menu
          sub_menu = !@item_block.nil? && (expand_inactive? || @active) ? @item_block.menu : ''
          unless @item_disabled
            item_text = view_object.link_to(@name, @url) + sub_menu
          else
            item_text = @name.html_safe + sub_menu
          end

          view_object.content_tag :li, item_text, :id => @item_id, :class => item_classes
        end 
      end
  
      module MenuRender      
        
        def active_item_name
          item = @items.find{|item| item.active}
          item.name unless item.nil?
        end
        
        def menu
          view_object.content_tag :ul, 
                                  @items.count > 0 ? @items.map{|item| item.menu}.sum : '', 
                                  :id => @item_block_id,
                                  :class => item_block_classes
        end 
      end
      
    end  
  end
end