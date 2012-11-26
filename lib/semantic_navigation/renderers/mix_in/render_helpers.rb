module SemanticNavigation
  module Renderers
    module MixIn
      module RenderHelpers

        def self.included(base)
          base.send :include, InstanceMethods
          base.extend(ClassMethods)
          base.class_eval do
            [:navigation, :node, :leaf, :link].each do |e|
              style_accessor :"#{e}_active_class" => [:active],
                             :"show_#{e}_active_class" => true,
                             :"show_#{e}_id" => true,
                             :"#{e}_default_classes" => []
            end
            style_accessor menu_tag: :ul
          end
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

          def property_for(class_name,name)
            class_object = "semantic_navigation/core/#{class_name}".classify.constantize
            class_object.class_eval "
              unless defined?(#{name})
                def #{name}
                  @#{name}
                end
              end
            "
          end
        end

        module InstanceMethods
          attr_accessor :from_level, :until_level, :except_for, :name

          def level=(level)
            @from_level = level
            @until_level = level
          end

          def levels=(level_range)
            @from_level = level_range.first
            @until_level = level_range.last
          end

          def initialize
            @view_object = SemanticNavigation::Configuration.view_object
          end

          private

          def content_tag(tag_name, content = nil, options={}, &block)
            @view_object.content_tag(tag_name, content, options) {yield if block_given?}
          end

          def link_to(link_name, url, options={})
            @view_object.link_to(link_name, url, options)
          end

          def merge_classes(name, active, object_classes = [])
            default_classes = send("#{name}_default_classes")
            active_classes = active && send("show_#{name}_active_class") ? send("#{name}_active_class") : nil
  
            classes = [*default_classes, *active_classes, *object_classes]
            !classes.empty? ? classes : nil
          end

          def show_id(name, id)
            id if send("show_#{name}_id")
          end

          def object_name(object)
            object.name(self.name)
          end

          def content_menu_tag(parameters)
            content_tag menu_tag, nil, parameters do
              yield
            end
          end
          
        end
      end
    end
  end
end
