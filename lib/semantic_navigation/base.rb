module SemanticNavigation
  class Base
    
    def initialize(options)
      @items = {}
      options.each do |option|
        self.instance_variable_set "@#{option}", options[option]
      end
    end
    
    def item(id, url = nil, options = {})
      name = ''
      if id.is_a? Hash
        name = id[id.keys.first]
        id = id.keys.first
      end
      
      options[:id] = id
      options[:name] = name
      options[:url] = url
      
      if url
        @items[id] = block_given? ? Node.new(options) : Leaf.new(options)
      else
        @items[id] = Disabled.new(options)
      end
    end
   
  end
end
