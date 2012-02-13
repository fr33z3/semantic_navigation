require 'semantic_navigation/item'

module SemanticNavigation
  class Menu 
      
   attr :menu_id, :items
   
   def initialize(options)
     @items = {}
     options.keys.each do |key|
       self.instance_variable_set("@#{key}",options[key])
     end
   end
   
   def method_missing(element_id, name = '', url = nil, item_options = {}, menu_options = {}, &block)
     item_options[:item_id] = element_id.to_s
     menu = block_given? ? Menu.new(menu_options) : nil
     @items[element_id] = Item.new item_options, menu
   end
      
  end
end