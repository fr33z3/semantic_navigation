module SemanticNavigation
  module Core
    module Helpers
    
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end
      
      module InstanceMethods
      end
      
      module ClassMethods
        def style_reader(syms)
          syms.each do |sym|
            class_eval(<<-EOS, __FILE__, __LINE__ + 1)
              @@#{sym} = nil unless defined? @@#{sym}
              @#{sym} = nil unless defined? @#{sym}

              def self.#{sym}
                @@#{sym}
              end

              def #{sym}
                @#{sym} || @@#{sym} 
              end 
            EOS
          end
        end

        def style_writer(hash)
          hash.keys.each do |key|
            class_eval(<<-EOS, __FILE__, __LINE__ + 1)
              @@#{key} = nil unless defined?
              @#{key} = nil unless defined? @#{key}

              def self.#{key}=(style_value)
                @@#{key} = style_value
              end

              def #{key}=(style_value)
                @#{key} = style_value
              end 
            EOS
            send "#{key}=", hash[key]
          end        
        end

        def style_accessor(hash)
          style_reader(hash.keys)
          style_writer(hash)
        end                
      end
      
    end
  end
end
