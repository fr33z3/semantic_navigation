require 'semantic_navigation/core/render'

module SemanticNavigation
  class Item
    include Core::Render
    
    @@active_class = 'active'
    @@show_active_class = true
    @@show_menu_id = true
    @@show_item_id = true
    @@show_name_id = true
    @@show_submenu = false
    
    attr_accessor :active_class, :show_active_class, :show_menu_id,
                  :show_item_id, :show_name_id, :show_submenu
    
    def initialize(id, args, parent)
      @item_id = id
      @name = args.first
      @url_options = args.second
      @parent = parent
      
      @sub_items = []
      
      set_as_active if active?
    end

    def method_missing(name, *args)
      item = SemanticNavigation::Item.new(name.to_s, args, self)
      @sub_items << item
      yield item if block_given?
    end

    def self.set_default_option(name, value)
      class_variable_set("@@#{name}".to_sym, value)
    end
    
    private
    
    def ul_id
      flag = @show_menu_id.nil? ? @@show_menu_id : @show_menu_id
      flag ? @item_id : nil
    end
    
    def li_id
      flag = @show_item_id.nil? ? @@show_item_id : @show_item_id
      flag ? @item_id : nil
    end
    
    def a_id
      flag = @show_name_id.nil? ? @@show_name_id : @show_name_id
      flag ? @item_id : nil
    end
    
    def classes
      active_class = @active_class.nil? ? @@active_class : @active_class
      flag = @show_active_class.nil? ? @@show_active_class : @show_active_class
      @active && flag ? active_class : nil 
    end
    
    def view_object
      @@view_object
    end
    
    def show_submenu?
      @show_submenu.nil? ? @@show_submenu : @show_submenu
    end
    
  end
end
