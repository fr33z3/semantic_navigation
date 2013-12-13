module SemanticNavigation
  module Core
    class Navigation < Base
      attr_accessor :sub_elements

      def initialize(options, level = 0)
        @sub_elements = []
        @scope_options = {}
        super options, level
      end

      #def item(id=nil, url, options={}, &block)
      def item(*attrs, &block)
        case attrs.size
        when 0
          raise '#item should receive at least url attr'
        when 1
          id = generate_sub_element_id
          url = attrs[0]
          options = {}
        when 2
          if attrs.last.is_a?(Hash) && !attrs.last.has_key?(:controller) && !attrs.last.has_key?(:action)
            id = generate_sub_element_id
            url, options = attrs
          else
            id, url = attrs
            options = {}
          end
        when 3
          id, url, options = attrs
        end
        
        options[:id] = id.to_sym
        options[:render_if] ||= @scope_options[:render_if]

        if url.is_a?(Array)
          options[:url] = [url].flatten(1).map{|url| decode_url(url)}
        else
          options[:url] = decode_url(url)
        end

        options[:i18n_name] = @i18n_name

        if block_given?
          element = Node.new(options, @level+1)
          element.instance_eval &block
        else
          element = Leaf.new(options, @level+1)
        end

        @sub_elements.push element
      end

      def header(id, options={})
        options[:id] = id.to_sym
        options[:render_if] ||= @scope_options[:render_if]
        options[:url] = nil
        options[:i18n_name] = @i18n_name
        @sub_elements.push Leaf.new(options, @level+1)
      end

      def divider(options = {})
        options[:id] = :divider
        options[:render_if] ||= @scope_options[:render_if]
        options[:url] = nil
        options[:i18n_name] = nil
        options[:name] = nil
        @sub_elements.push Leaf.new(options, @level+1)
      end

      def method_missing(m,*args,&block)
        if m.to_s.match(/^[_]+$/).to_a.size > 0
          divider
        else
          super(m,args,&block)
        end
      end

      def scope(options = {}, &block)
        @scope_options = options
        self.instance_eval &block
        @scope_options = {}
      end

      def mark_active
        @sub_elements.each do |element|
          element.mark_active
        end
        @active = !@sub_elements.find{|element| element.active}.nil?
      end

      private

      def generate_sub_element_id
        "#{self.id}_#{@sub_elements.size}".to_sym
      end

      def decode_url(url)
        if url.is_a? String
          controller_name, action_name = url.split('#')
          if controller_name && action_name
            decoded_url = {:controller => controller_name, :action => action_name}
          end
        end
        decoded_url || url
      end

    end
  end
end
