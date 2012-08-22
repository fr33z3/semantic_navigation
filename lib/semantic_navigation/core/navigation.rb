module SemanticNavigation
  module Core
    class Navigation < Base
      attr :sub_elements
      
      def initialize(options, level = 0)
        @sub_elements = []
        super options, level
      end

      def item(id, url=nil, options={}, &block)
        options[:id] = id.to_sym
        
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
          #Deprecation warning message
          #TODO:Should be deleted after moving the header and divider definition via item
          if element.url.nil? && !element.name.empty?
            puts 'Warning: do not define `headers` using `item` method. Use `header` instead. This logic will be deprecated soon.'
          elsif element.url.nil? && element.name.empty?
            puts 'Warning: do not define `dividers` using `item` method. Use `divider` instead. This logic will be deprecated soon.'
          end
        end
        
        @sub_elements.push element
      end

      def header(id, options={})
        options[:id] = id.to_sym
        options[:url] = nil
        options[:i18n_name] = @i18n_name
        @sub_elements.push Leaf.new(options, @level+1)
      end

      def divider
        options = {:id => :divider,
                   :url => nil,
                   :i18n_name => nil}
        @sub_elements.push Leaf.new(options, @level+1)
      end

      def method_missing(m,*args,&block)
        if m.to_s.match(/^[_]+$/).to_a.size > 0
          divider
        else
          super(m,args,&block)
        end
      end

      def mark_active
        @sub_elements.each do |element| 
          element.mark_active
        end
        @active = !@sub_elements.find{|element| element.active}.nil?
      end

      private

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
