module SemanticNavigation
  module Renderers
    module RenderHelpers
      
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        def style_accessor(hash)
          hash.keys.each do |key|
            class_eval "
             @@#{key} = nil
             @#{key} = nil

             def self.#{key}(value)
               @@#{key}= value
             end

             def #{key}(value = nil)
               @#{key} = value unless value.nil?
               @#{key}.nil? ? @@#{key} : @#{key}
             end

             def #{key}=(value)
               @#{key} = value
             end
            "
            send key, hash[key]
          end        
        end
      end
      
      module InstanceMethods  
        attr_accessor :from_level, :until_level, :except_for
        
        def level=(level)
          @from_level = level
          @until_level = level
        end
        
        def levels=(level_range)
          @from_level = level_range.first
          @until_level = level_range.last
        end
        
        def initialize(view_object)
          @view_object = view_object
        end
        
        def render_navigation(object)
          navigation(object) do
            while !object.class.in?(SemanticNavigation::Core::Leaf, NilClass) && 
                  from_level.to_i > object.level
              object = object.sub_elements.find{|e| e.active}
            end
            show = !until_level.nil? && !object.nil? ? object.level <= until_level : true
            if !object.class.in?(SemanticNavigation::Core::Leaf, NilClass) && show
              object.sub_elements.map{|element| element.render(self)}.compact.sum
            end
          end
        end

        def render_node(object)
          if !object.id.in?([except_for].flatten)
            node(object) do
              render_node_content(object)
            end
          end
        end
        
        def render_node_content(object)
          if (!until_level.nil? && until_level >= object.level) || until_level.nil?
            node_content(object) do
              object.sub_elements.map{|element| element.render(self)}.compact.sum
            end
          end
        end

        def render_leaf(object)
          if !object.id.in?([except_for].flatten)
            leaf(object)
          end
        end        

        private

        def content_tag(tag_name, content, options={}, &block)
          @view_object.content_tag(tag_name, content, options) {yield}
        end

        def link_to(link_name, url, options={})
          @view_object.link_to(link_name, url, options)
        end

        def merge_classes(name, active, object_classes = [])
          classes = []
          classes += [send("#{name}_default_classes")].flatten
          if active && send("show_#{name}_active_class")
            classes.push [send("#{name}_active_class")].flatten
          end
          classes += [object_classes].flatten
        end

        def show_id(name, id)
          id if send("show_#{name}_id")
        end
        
      end
  
    end    
  end
end
