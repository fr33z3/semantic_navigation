module SemanticNavigation
  module Core
    module DefaultStyles
      
      def menu_default_styles
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
         :disabled_options => {}
        }
      end
      
      def bootstrap_default_menu
        {:expand_inactive => false,
         
         :item_id_visible => false,
         :item_block_id_visible => false,
         :link_id_visible => false,
          
         :item_block_classes => ['nav','nav-list'],         
         :disabled_classes => ['nav-header'],
        }        
      end
      
      def breadcrumb_default_styles
        
      end
      
      def tabs_default_styles
        
      end
      
      def pills_default_styles
        
      end
     
    end
  end
end