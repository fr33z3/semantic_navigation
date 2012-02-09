module SemanticNavigation
  module Core
    module Render
      
      def render(last_level = nil)
        return nil if !render_item?
        if @parent
          level_condition = last_level.nil? ? true : @level < last_level
          sub = (@active || show_submenu?) && level_condition ? render_submenu(last_level) : nil
          view_object.content_tag(:li, item_link(classes) + sub, :id => li_id, :class => classes)
        else
          render_submenu
        end  
      end

      def render_submenu(last_level = nil)
        if @sub_items.count > 0
          sub = @sub_items.map{|s| s.render(last_level)}.sum
          view_object.content_tag(:ul, sub, :id => ul_id, :class => menu_classes) if sub != 0
        end
      end
      
      def set_as_active
        @active = true
        @parent.set_as_active if @parent
      end
      
      def find_active_item
        item = nil
        if active?
          item = self
        elsif @active
          @sub_items.each do |s|
            buff = s.find_active_item
            item = buff if !buff.nil?
          end
        end
        item
      end 
      
      def render_breadcrumb
        breadcrumb = nil
        if @active
          if @name
            breadcrumb = view_object.content_tag(:li, item_link(breadcrumb_classes) + breadcrumb_divider, :id => li_id) if @name  
          end
          buff = @sub_items.map{|s| s.render_breadcrumb}.find{|s| !s.nil?}
          if !breadcrumb.nil?
            breadcrumb += buff if !buff.nil?
          else
            breadcrumb = buff
          end
        end
        breadcrumb = view_object.content_tag(:ul, breadcrumb, :id => ul_id, :class => breadcrumb_menu_classes) if !@parent
        breadcrumb
      end
      
      def render_levels levels
        if levels.is_a? Fixnum
          levels = [levels]
        else
          levels = levels.to_a
        end
        item = find_active_item
        return nil if item.nil?
        while item.level > levels.first-1 && item.level != 0
          item = item.parent
        end
        item.level == levels.first-1 ? item.render_submenu(levels.last) : nil
      end
      
      def render_from level_num
        item = find_active_item
        return nil if item.nil?
        while item.level > level_num-1 && item.level != 0
          item = item.parent
        end
        item.level == level_num-1 ? item.render_submenu : nil 
      end
      
      private
    
      def active?
        !@parent.nil? ? view_object.current_page?(@url_options) : false
      end
      
      def item_link(classes_string)
        view_object.link_to @name, @url_options, :class => classes_string, :id => a_id    
      end
      
    end  
  end
end

