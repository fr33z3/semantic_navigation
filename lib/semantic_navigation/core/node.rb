module SemanticNavigation
  module Core
    class Node < Navigation      
      attr :url, :name
      
      def initialize(options, level)
        super options, level
        @name ||= i18n_name || ""
      end
      
      private
      
      def i18n_name
        @i18n_hash.is_a?(Hash) ? @i18n_hash[:_name_] : @i18n_hash
      end
    end
  end
end
