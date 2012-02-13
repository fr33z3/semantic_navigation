module SemanticNavigation
  class Item

    attr :item_id, :name, :url, :sub_menu

    def initialize(options, sub_menu = nil)
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
        @sub_menu = sub_menu
      end
    end
    
  end
end
