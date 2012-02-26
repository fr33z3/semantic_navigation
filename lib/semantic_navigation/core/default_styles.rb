module SemanticNavigation
  module Core
    module DefaultStyles
      
      def default_styles
        {:expand_inactive => true,
         :item_active_class => 'active',
         :link_active_class => 'active',
         
         :item_id_visible => true,
         :item_block_id_visible => true,
         :link_id_visible => true,
          
         :item_mark_active => true,
         :link_mark_active => false,
         
         :item_classes => [],
         :item_block_classes => [],
         :link_classes => [],
         :disabled_classes => [],
                      
         :item_options => {},
         :item_block_options => {},
         :link_options => {},
         :disabled_options => {},
         
         :icon_before => nil,
         :icon_after => nil,
         :active_icon_before => nil,
         :active_icon_after => nil
        }
      end
      
      def bootstrap_default_menu
        {:expand_inactive => false,
         
         :item_id_visible => false,
         :item_block_id_visible => false,
         :link_id_visible => false,
          
         :item_block_classes => ['nav','nav-list'],         
         :disabled_classes => ['nav-header'],
         :icon_before => proc {|icon| "<i class='icon-#{icon}'></i>" unless icon.nil?},
         :active_icon_before => proc {|icon| "<i class='icon-#{icon} icon-white'></i>" unless icon.nil?}
        }        
      end
     
    end
  end
end