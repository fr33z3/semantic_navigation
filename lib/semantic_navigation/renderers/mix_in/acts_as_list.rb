module SemanticNavigation
  module Renderers
    module MixIn
      module ActsAsList

        def render_navigation(object)
          return '' unless object.render_if
          navigation(object) do
            object = first_rendering_object(object)
            if !is_leaf?(object) && show_object?(object)
              object.sub_elements.map{|element| element.render(self)}.compact.sum
            end
          end
        end

        def render_node(object)
          if !is_exception?(object) && object.render_if
            content = render_node_content(object)
            if content
              node(object) { content }
            else
              render_leaf(object)
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
          leaf(object) if !is_exception?(object) && object.render_if
        end

        private

        def is_exception?(object)
          object.id.in?([except_for].flatten)
        end

        def first_rendering_object(object)
          while !is_leaf?(object) && from_level.to_i > object.level
            object = object.sub_elements.find{|e| e.active}
          end
          object
        end

        def is_leaf?(object)
          object.class.in?([SemanticNavigation::Core::Leaf, NilClass])
        end

        def show_object?(object)
          until_level && object ? object.level <= until_level : true
        end

      end
    end
  end
end
