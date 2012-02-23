module SemanticNavigation
  module Core
    module ItemBlockStyles
      
      private
      
      def item_block_classes(render_name)
        #TODO: make the code understand that string should be used too
        style = instance_variable_get("@#{render_name}")
        classes = current_style[:item_block_classes]
        classes += @item_block_classes unless @item_block_classes.nil?
        classes += style[:item_block_classes] if !style.nil? && !style[:item_block_classes].nil?
        !classes.empty? ? classes : nil
      end
      
      def item_block_options(render_name)
        options = current_style[:item_block_options]
        options.merge!(@item_block_options) unless @item_block_options.nil?
        style = instance_variable_get("@#{render_name}")
        options.merge!(style[:item_block_options]) if !style.nil? && !style[:item_block_options].nil?
        options
      end
      
      def item_block_id_string
        @item_block_id if current_style[:item_block_id_visible]
      end
      
      def current_style
        SemanticNavigation::Configuration.current_style
      end
      
    end
  end
end