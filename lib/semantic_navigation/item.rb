require 'semantic_navigation/core/render'
require 'semantic_navigation/core/item_styles'

module SemanticNavigation
  class Item
    
    include SemanticNavigation::Core::Render::ItemRender
    include SemanticNavigation::Core::ItemStyles
    
    attr :item_id, :name, :active
    attr_accessor :item_block
    
    def initialize(options, item_block = nil)
      @active = false
      @item_block = item_block
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
      end
      unless @url.nil?
        @active = view_object.current_page? @url
      else
        @item_disabled = true
      end
      @active ||= @item_block.items.select{|item| item.active == true}.count > 0 unless @item_block.nil?
    end
   
    private
    
    def view_object
      SemanticNavigation::Configuration.view_object
    end
   
  end
end
