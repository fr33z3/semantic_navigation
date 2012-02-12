require 'semantic_navigation/item'

module SemanticNavigation
  class Menu 
      
   attr :menu_id, :name, :link
   
   def initialize(options)
     @elements = {}
     options.keys.each do |key|
       self.instance_variable_set("@#{key}",options[key])
     end
   end
   
   def method_missing(element_id, name = '', url = nil, options = {}, &block)
     if block_given?
       options[:menu_id] = element_id.to_s
       @elements[element_id] = Menu.new options
       @elements[element_id].instance_eval(&block)
     else
       options[:item_id] = element_id.to_s
       @elements[element_id] = Item.new options
     end
   end
   
   def render(options)
   
   end
   
  end
end