module SemanticNavigation
  module Core
    class Leaf < Base
      attr :url
      
      def initialize(options, level)
        super options, level
      end
      
      def name
        @name || I18n.t(@i18n_name) || ''
      end
      
    end    
  end
end
