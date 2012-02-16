require 'semantic_navigation/core/render'

module SemanticNavigation
  class Item
    
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper 
    include SemanticNavigation::Core::Render::ItemRender
    
    attr :item_id, :name, :url, :sub_menu,
         :item_classes

    def initialize(options, sub_menu = nil)
      @sub_menu = sub_menu
      options.keys.each do |key|
        self.instance_variable_set("@#{key}",options[key])
      end
    end
    
  end
end
