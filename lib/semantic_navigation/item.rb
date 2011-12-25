require 'semantic_navigation/core/render'
require 'semantic_navigation/core/procs'
module SemanticNavigation
  class Item
    include Core::Render
    include Core::Procs
    
    @@active_class = 'active'
    @@show_active_class = true
    @@show_menu_id = true
    @@show_item_id = true
    @@show_name_id = true
    @@show_submenu = false
    @@menu_prefix = ''
    @@item_perfix = ''
    @@name_prefix = ''
    
    attr_accessor :active_class, :show_active_class, :show_menu_id,
                  :show_item_id, :show_name_id, :show_submenu,
                  :menu_prefix, :item_prefix, :name_prefix,
                  :item_classes
    
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
      prefix = @menu_prefix.nil? ? @@menu_prefix : @menu_prefix
      flag = @show_menu_id.nil? ? @@show_menu_id : @show_menu_id
      flag ? prefix+@item_id : nil
    end
    
    def li_id
      prefix = @item_prefix.nil? ? @@item_prefix : @item_prefix
      flag = @show_item_id.nil? ? @@show_item_id : @show_item_id
      flag ? prefix+@item_id : nil
    end
    
    def a_id
      prefix = @name_prefix.nil? ? @@name_prefix : @name_prefix
      flag = @show_name_id.nil? ? @@show_name_id : @show_name_id
      flag ? prefix+@item_id : nil
    end
    
    def classes
      class_array = []
      class_array << item_classes
      active_class = @active_class.nil? ? @@active_class : @active_class
      flag = @show_active_class.nil? ? @@show_active_class : @show_active_class
      if @active && flag
        class_array << active_class
      end
      class_array.flatten.join(' ')
    end
    
    def view_object
      @@view_object
    end
    
    def show_submenu?
      @show_submenu.nil? ? @@show_submenu : @show_submenu
    end
    
  end
end
