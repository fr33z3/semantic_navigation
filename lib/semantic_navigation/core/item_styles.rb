module SemanticNavigation
  module Core
    module ItemStyles
      
      private
      
      def item_name
        @name
      end
      
      def item_classes(render_name = :menu)
        @item_classes ||= []
        c = @item_classes
        c += [active_class] if @active
        c
      end
      
      def active_class
        current_style[:item_active_class]
      end
      
      def expand_inactive?
        current_style[:expand_inactive]
      end
      
      def current_style
        SemanticNavigation::Configuration.current_style
      end
   
    end
  end
end