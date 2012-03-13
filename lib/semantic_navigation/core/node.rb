module SemanticNavigation
  module Core
    class Node < Navigation      
      attr :url, :name
      
      def initialize(options, level)
        super options, level
        @name ||= ""
      end
    end
  end
end
