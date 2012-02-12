module SemanticNavigation
  class Item

    attr :item_id, :name, :url
   
    def initialize(options)
      @elements = {}
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
      end
    end
    
  end
end
