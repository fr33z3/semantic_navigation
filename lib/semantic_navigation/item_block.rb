require 'semantic_navigation/item'
require 'semantic_navigation/core/render'
require 'semantic_navigation/core/render_helpers'
require 'semantic_navigation/core/item_block_styles'

module SemanticNavigation
  class ItemBlock

   include SemanticNavigation::Core::Render::MenuRender
   include SemanticNavigation::Core::RenderHelpers
   include SemanticNavigation::Core::ItemBlockStyles
   
   attr :item_block_id, :items
   
   def initialize(options)
     @items = []
     options.keys.each do |key|
       self.instance_variable_set("@#{key}",options[key])
     end
   end
   
   def method_missing(element_id, name = '', url = nil, item_options = {}, item_block_options = {}, &block)
     item_block_options[:item_block_id] ||= element_id.to_s
     item_options = {:item_id => element_id.to_s,
                     :url => url,
                     :name => name}
     
     item_block = nil
     if block_given?
       item_block = ItemBlock.new(item_block_options)
       item_block.instance_eval(&block)
     end
     @items.push(Item.new item_options, item_block)
   end
   
   private
    
   def view_object
     SemanticNavigation::Configuration.view_object
   end
        
  end
end