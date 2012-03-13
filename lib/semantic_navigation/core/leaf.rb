module SemanticNavigation
  module Core
    class Leaf < Base
      attr :url, :name
      
      def initialize(options, level)
        super options, level
        @name ||= ""
      end
      
    end    
  end
end
