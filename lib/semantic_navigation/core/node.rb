module SemanticNavigation
  module Core
    class Node < Base
      
      attr :sub_elements
      
      def initialize(id, url, options, level)
        @sub_elements = []
        super
      end
      
      def item(id, url=nil, options={}, &block)
        if block_given?
          element = Node.new(id, url, options, @level+1)
          element.instance_eval &block
        else
          element = Leaf.new(id, url, options, @level+1)
        end
        @sub_elements.push element
      end 
      
    end
  end
end
