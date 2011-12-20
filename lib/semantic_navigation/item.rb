module SemanticNavigation
  class Item
 
    def initialize(id, args)
      @id = id
      @name = args.first
      @url_options = args.second
      @sub_items = {}
    end

    def method_missing(name, *args)
      #def method_missing(name)
      #item = SemanticNavigation::Menu.new
      #@menus.merge!({name.to_sym => menu})
      #yield menu if block_given?
    end

    def render(view_object)
      url = view_object.url_for @url_options
      ["<li>",
        "<a href = '#{url}'>",
          "#{@name}",
        "</a>",
      "</li>"].join
    end
  end
end
