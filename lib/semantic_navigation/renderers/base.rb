module SemanticNavigation
  module Renderers
    class Base
    
      attr_accessor :from_level, :until_level
      
      cattr_accessor :navigation_active_class, :node_active_class, :leaf_active_class, 
                     :link_active_class, :show_navigation_active_class,
                     :show_node_active_class, :show_leaf_active_class, 
                     :show_link_active_class,
                     :show_navigation_id, :show_node_id, :show_leaf_id, :show_link_id,
                     :navigation_default_classes, :leaf_default_classes, 
                     :node_default_classes, :link_default_classes
      
      @@navigation_active_class = [:active]
      @@node_active_class = [:active]
      @@leaf_active_class = [:active]
      @@link_active_class = [:active]
      
      @@show_navigation_active_class = true
      @@show_node_active_class = true
      @@show_leaf_active_class = true
      @@show_link_active_class = true
      
      @@show_navigation_id = true
      @@show_node_id = true
      @@show_leaf_id = true
      @@show_link_id = true
      
      @@navigation_default_classes = []
      @@node_default_classes = []
      @@leaf_default_classes = []
      @@link_default_classes = []
          
      def initialize(view_object)
        @view_object = view_object
      end
      
      def render_navigation(object)
        object.mark_active(@view_object)
      end
      
      private
      
      def tag(tag_name, object, options = {}, &block)
        object_name = object.class.name.split('::').last.downcase
        options ={:id => ids(object_name, object.id),
                  :class => classes(object_name, object.active)
                 }.merge(options)
        content_tag(tag_name, nil, options) {yield}
      end
      
      def link(object, options = {})
        options = {:id => ids('link', object.id),
                   :class => classes('link', object.active) 
                  }.merge(options)
        link_to(object.id, object.url, options)
      end
      
      def content_tag(tag_name, content, options={}, &block)
        @view_object.content_tag(tag_name, content, options) {yield}
      end
      
      def link_to(link_name, url, options={})
        @view_object.link_to(link_name, url, options)
      end
      
      def classes(name, active)
        classes = []
        classes += [send("#{name}_default_classes")].flatten
        if active && send("show_#{name}_active_class")
          classes.push [send("#{name}_active_class")].flatten
        end
      end
      
      def ids(name, id)
        result_id = nil
        result_id = id if send("show_#{name}_id")
        result_id
      end
  
    end    
  end
end
