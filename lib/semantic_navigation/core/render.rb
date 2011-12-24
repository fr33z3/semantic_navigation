module SemanticNavigation
  module Core
    module Render
      
      def render(view_object)
        @view_object = view_object
        if parent
          set_as_active if active?
          sub = render_subitems
          link = view_object.link_to @name, @url_options, :class => classes, :id => a_id
          view_object.content_tag(:li, link + sub, :id => li_id, :class => classes)
        else
          render_subitems
        end  
      end
      
      def set_as_active
        @active = true
        parent.set_as_active if parent
      end
      
      private
    
      def render_subitems
        if @sub_items.count > 0
          sub = @sub_items.map{|s| s.render(@view_object)}.sum
          @view_object.content_tag(:ul, sub, :id => ul_id)
        end
      end
    
      def active?
        @view_object.current_page?(@url_options)
      end
    
      def parent
        @parent.is_a?(SemanticNavigation::Item) ? @parent : nil
      end
      
    end  
  end
end

