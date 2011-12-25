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
      
     def active_item_name
       if @active && @sub_items.count > 0
         name = @sub_items.map{|s| s.active_item_name}.find{|s| s != nil}
       end
       if active?
         name = @name  
       end
       name
     end
      
      private
    
      def render_submenu
        if @sub_items.count > 0
          sub = @sub_items.map{|s| s.render}.sum
          view_object.content_tag(:ul, sub, :id => ul_id) if sub != 0
        end
      end
    
      def active?
        view_object.current_page?(@url_options) if !@url_options.nil?
      end
    end  
  end
end

