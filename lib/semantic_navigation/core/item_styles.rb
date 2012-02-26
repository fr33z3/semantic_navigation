module SemanticNavigation
  module Core
    module ItemStyles
      
      private
      
      def icon(position)
        icon = nil
        icon = @active ? current_style[:"active_icon_#{position}"] || current_style[:"icon_#{position}"] : current_style[:"icon_#{position}"]
        icon = icon.call(@icon, item_block.nil? || item_block.empty?) if icon.is_a? Proc
        icon
      end
      
      def link_name(render_name)
        style = instance_variable_get("@#{render_name}")
        name = style[:link_name] unless style.nil?
        name ||= @link_name
        [icon(:before),
         name,
         icon(:after)].join.html_safe
      end
      
      def item_classes(render_name)
        #TODO: make the code understand that string should be used too
        style = instance_variable_get("@#{render_name}")
        classes = current_style[:item_classes]
        classes += @item_classes unless @item_classes.nil?
        classes += style[:item_classes] if !style.nil? && !style[:item_classes].nil?
        classes += [current_style[:item_active_class]] if @active && current_style[:item_mark_active]
        !classes.empty? ? classes : nil
      end

      def link_classes(render_name)
        #TODO: make the code understand that string should be used too
        style = instance_variable_get("@#{render_name}")
        classes = current_style[:link_classes]
        classes += @link_classes unless @link_classes.nil?
        classes += style[:link_classes] if !style.nil? && !style[:link_classes].nil?
        classes += [current_style[:link_active_class]] if @active && current_style[:link_mark_active]
        !classes.empty? ? classes : nil
      end
      
      def disabled_classes(render_name)
        #TODO: make the code understand that string should be used too
        r = current_style[:disabled_classes]
        r += @item_classes if !@item_classes.nil?
        rc = instance_variable_get("@#{render_name}")
        if !rc.nil? && !rc[:item_classes].nil?
          r += rc[:item_classes]
        end
        r
      end      
      
      def item_options(render_name)
        options = current_style[:item_options]
        options.merge!(@item_options) unless @item_options.nil?
        style = instance_variable_get("@#{render_name}")
        options.merge!(style[:item_options]) if !style.nil? && !style[:item_options].nil?
        options
      end

      def disabled_options(render_name)
        options = current_style[:disabled_options]
        options.merge!(@item_options) unless @item_options.nil?
        style = instance_variable_get("@#{render_name}")
        options.merge!(style[:item_options]) if !style.nil? && !style[:item_options].nil?
        options
      end
      
      def item_id_string
        @item_id if current_style[:item_id_visible]
      end
      
      def link_id_string
        @link_id || @item_id if current_style[:link_id_visible]
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