module SemanticNavigation
  module Core
    module DefaultStyles
      
      def menu_default_styles
        {:expand_inactive => true,
         :item_active_class => 'active',
         :menu_active_class => 'active',
         :link_active_class => 'active',
          
         :item_mark_active => true,
         :menu_mark_active => false,
         :link_mark_active => false,
         
         :item_classes => [],
         :menu_classes => [],
         :link_classes => [],
         :disabled_classes => [],
                      
         :item_params => [],
         :menu_params => [],
         :link_params => [],
         :disabled_params => [],
                     
         :item_wrapper => [],
         :menu_wrapper => [],
         :link_wrapper => []
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