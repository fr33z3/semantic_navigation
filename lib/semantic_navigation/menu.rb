require 'semantic_navigation/item'
require 'semantic_navigation/core/render'
require 'semantic_navigation/core/render_helpers'

module SemanticNavigation
  class Menu 

   include ActionView::Helpers::TagHelper
   include SemanticNavigation::Core::Render::MenuRender
   include SemanticNavigation::Core::RenderHelpers
   
   attr :menu_id, :items,
        :menu_classes
   
   def initialize(options)
     @items = []
     options.keys.each do |key|
       self.instance_variable_set("@#{key}",options[key])
     end
   end
   
   def method_missing(element_id, name = '', url = nil, options = {}, &block)
     menu_options = {:menu_id => element_id.to_s}
     item_options = {:item_id => element_id.to_s,
                     :url => url,
                     :name => name}
     
     options.keys.each do |key|
       if key.to_s[0..3] == 'menu'
         menu_options[key] = options[key]
       elsif key.to_s[0..3] == 'item'
         item_options[key] = options[key]
       end
     end
     
     menu = nil
     if block_given?
       menu = Menu.new(menu_options)
       menu.instance_eval(&block)
     end
     @items.push(Item.new item_options, menu)
   end
        
  end
end