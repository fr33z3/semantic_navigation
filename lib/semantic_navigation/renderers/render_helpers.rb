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
        
        def initialize(view_object)
          @view_object = view_object
        end
        
        def render_navigation(object)
          navigation(object) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end

        def render_node(object)
          node(object) do
            object.sub_elements.sum{|element| element.render(self)}
          end
        end

        def render_leaf(object)
          leaf(object)
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
