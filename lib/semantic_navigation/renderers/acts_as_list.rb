module SemanticNavigation
  module Renderers
    module ActsAsList
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
    end
  end
end
