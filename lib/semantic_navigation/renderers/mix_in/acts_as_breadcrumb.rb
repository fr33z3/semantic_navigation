module SemanticNavigation
  module Renderers
    module MixIn
      module ActsAsBreadcrumb

        def render_navigation(object)
          return '' unless object.render_if
          navigation(object) do
            while !object.class.in?([SemanticNavigation::Core::Leaf, NilClass]) &&
                  from_level.to_i > object.level
              object = object.sub_elements.find(&:active)
            end
            unless object.class.in?([SemanticNavigation::Core::Leaf, NilClass])
              active_element = object.sub_elements.find{|e| e.active}
              active_element.render(self) if active_element
            end
          end
        end

        def render_node(object)
          active_element = object.sub_elements.find{|e| e.active}
          if active_element && !active_element.id.in?([except_for].flatten) && active_element.render_if
            render_element = active_element.render(self)
          end
          if render_element
            if object.skip?(self.name)
              render_element
            else
              node(object){ render_element }
            end
          else
            render_leaf(object)
          end
        end

        def render_leaf(object)
          show = !until_level.nil? ? object.level <= until_level+1 : true
          show &= !object.skip?(self.name)
          return nil unless show

          leaf(object)
        end
      end
    end
  end
end
