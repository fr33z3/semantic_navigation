module SemanticNavigation
  module Core
    class Navigation < Base
      attr :sub_elements
      
      def initialize(options, level = 0)
        @sub_elements = []
        super options, level
      end

      def item(id, url=nil, options={}, &block)
        options[:id] = id.to_sym
        options[:url] = url unless url.nil?
        options[:i18n_hash] = @i18n_hash[id] if @i18n_hash.is_a?(Hash)
        
        if block_given?
          options[:i18n_hash]
          element = Node.new(options, @level+1)
          element.instance_eval &block
        else
          element = Leaf.new(options, @level+1)
        end
        
        @sub_elements.push element
      end 
    end
  end
end
