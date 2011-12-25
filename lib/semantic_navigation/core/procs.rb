module SemanticNavigation
  module Core
    module Procs
    
      def show_if
        @condition = Proc.new
      end
      
      def render_item?
        !@condition.nil? ? @condition.call : true
      end
           
    end
  end
end
