module SemanticNavigation
  module Core
    class Leaf < Base
      attr :url, :link_classes
      
      def initialize(options, level)
        super options, level
      end
      
      def name
        rendering_name = @name || I18n.t("#{@i18n_name}.#{@id}", :default => '')
        if rendering_name.is_a?(Proc)
          view_object.instance_eval(&rendering_name).to_s
        else
          rendering_name
        end
      end
      
      def mark_active
        if @url
          @active = view_object.current_page?(@url) rescue false
        else
          @active = false
        end
      end
      
    end    
  end
end
