require 'semantic_navigation/core/render'

module SemanticNavigation
  class Item
    
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper 
    include SemanticNavigation::Core::Render::ItemRender
    
    attr :item_id, :name, :url, :sub_menu,
         :item_classes, :active
    
    def initialize(options, sub_menu = nil)
      @active = false
      @sub_menu = sub_menu
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
      end
      @active = view_object.current_page?(@url) unless url.nil?
      @active ||= @sub_menu.items.select{|item| item.active == true}.count > 0 unless @sub_menu.nil?
    end
    
    private
    
    def view_object
      SemanticNavigation::Configuration.view_object
    end
    
  end
end
