module SemanticNavigation
  module Core
    class Node < Navigation      
      attr :url, :link_classes, :node_classes
      
      def initialize(options, level)
        super options, level
      end
      
      def name
        @name || i18n_name || ''
      end
      
      def mark_active(view_object)
        @sub_elements.each{|element| element.mark_active(view_object)}
        @active = view_object.current_page?(@url)
        @active |= !@sub_elements.find{|element| element.active}.nil?
      end
            
      private
      
      def i18n_name
        I18n.t(@i18n_name).is_a?(Hash) ? I18n.t("#{@i18n_name}._name_") : I18n.t(@i18n_name)
      end
      
    end
  end
end
