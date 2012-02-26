module SemanticNavigation
  module Core
    module RenderHelpers
      def levels(range)
        from_menu = self
        if range.is_a? Fixnum
          from_menu.until_level(range)
          from_menu = from_menu.from_level(range)
        elsif range.is_a?(Range) || range.is_a?(Array)
          from_menu.until_level(range.last)
          from_menu = from_menu.from_level(range.first)
        end
        from_menu
      end
        
      def from_level(level)
        from_menu = self
        if level > 0
          next_item = @items.find{|item| item.active && !item.item_block.nil?} || @items.first
          from_menu = next_item.item_block.from_level(level-1) unless next_item.nil? && next_item.item_block.nil?
        end
        from_menu
      end
        
      def until_level(level)
        @items.each do |item|
          if level > 0
            item.item_block.until_level(level-1) unless item.item_block.nil?
          else
            item.item_block = nil
          end
        end
        self
      end
        
      def from_menu(name)
        return self if name.to_s == @menu_id
        from_menu = nil
        @items.each do |item|
          from_menu ||= item.item_block.from_menu(name)
        end
        from_menu
      end
      
      def except_for(names)
        @items = @items.select do |item|
          !item.item_id.to_sym.in?(names.map{|n| n.to_sym})
        end
        @items.each do |item|
          item.item_block.except_for(names) unless item.item_block.nil?
        end
        self
      end
      
    end
  end
end
