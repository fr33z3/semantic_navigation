module SemanticNavigation
  module Core
    class Leaf < Base
      attr :url, :link_classes
      
      def initialize(options, level)
        super options, level
      end
      
      def name
        @name || I18n.t(@i18n_name, :default => '')
      end
      
      def mark_active(view_object)
        if @url
          @active = view_object.current_page?(@url)
        else
          @active = false
        end
      end
      
    end    
  end
end
