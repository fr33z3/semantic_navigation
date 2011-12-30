module SemanticNavigation
  module Core
    module Render
      
      def render
        return nil if !render_item?
        if @parent
          sub = @active || show_submenu? ? render_submenu : nil
          link = view_object.link_to @name, @url_options, :class => classes, :id => a_id
          view_object.content_tag(:li, link + sub, :id => li_id, :class => classes)
        else
          render_submenu
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
            link = view_object.link_to @name, @url_options, :id => a_id
            breadcrumb = view_object.content_tag(:li, link + breadcrumb_name, :id => li_id) if @name  
          end
          buff = @sub_items.map{|s| s.render_breadcrumb}.find{|s| !s.nil?}
          if !breadcrumb.nil?
            breadcrumb += buff if !buff.nil?
          else
            breadcrumb = buff
          end
        end
        breadcrumb = view_object.content_tag(:ul, breadcrumb, :id => ul_id, :class => breadcrumb_classes) if !@parent
        breadcrumb
      end
      
      private
  
      def render_submenu
        if @sub_items.count > 0
          sub = @sub_items.map{|s| s.render}.sum
          view_object.content_tag(:ul, sub, :id => ul_id) if sub != 0
        end
      end
    
      def active?
        !@parent.nil? ? view_object.current_page?(@url_options) : false
      end
    end  
  end
end

