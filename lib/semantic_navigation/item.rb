require 'semantic_navigation/core/render'

module SemanticNavigation
  class Item
    
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper 
    include SemanticNavigation::Core::Render::ItemRender
    
    attr :item_id, :name, :url,
         :item_classes, :active
    attr_accessor :sub_menu
    
    def initialize(options, sub_menu = nil)
      @active = false
      @sub_menu = sub_menu
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
      end
      unless @url.nil?
        @active = view_object.current_page? @url
      else
        @item_disabled = true
      end
      @active ||= @sub_menu.items.select{|item| item.active == true}.count > 0 unless @sub_menu.nil?
    end
    
    private
    
    def view_object
      SemanticNavigation::Configuration.view_object
    end
    
  end
end
