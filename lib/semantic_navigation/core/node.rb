module SemanticNavigation
  module Core
    class Node < Navigation      
      attr :url
      
      def initialize(options, level)
        super options, level
      end
      
      def name
        @name || i18n_name || ''
      end
            
      private
      
      def i18n_name
        I18n.t(@i18n_name).is_a?(Hash) ? I18n.t("#{@i18n_name}._name_") : I18n.t(@i18n_name)
      end
    end
  end
end
