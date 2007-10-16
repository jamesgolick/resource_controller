module ResourceController
  module Accessors
    private
      def block_accessor(*accessors)
        accessors.each do |block_accessor|
          class_eval <<-"end_eval", __FILE__, __LINE__

            def #{block_accessor}(&block)
              @#{block_accessor} = block if block_given?
              @#{block_accessor}
            end

          end_eval
        end
      end
      
      def scoping_reader(*accessor_names)
        accessor_names.each do |accessor_name|        
          class_eval <<-"end_eval", __FILE__, __LINE__
            def #{accessor_name}(&block)
              @#{accessor_name}.instance_eval &block if block_given?
              @#{accessor_name}
            end
          end_eval
        end
      end
      
      def class_scoping_reader(accessor_name, start_value)
        class_variable_set "@@#{accessor_name}", start_value
        
        class_eval <<-"end_eval", __FILE__, __LINE__
          def self.#{accessor_name}(&block)
            @@#{accessor_name}.instance_eval &block if block_given?
            @@#{accessor_name}
          end
        end_eval
      end
      
      def reader_writer(accessor_name)
        class_eval <<-"end_eval", __FILE__, __LINE__
          def #{accessor_name}(*args)
            @#{accessor_name} = args.first unless args.empty?
            @#{accessor_name}
          end
        end_eval
      end
      
      def class_reader_writer(accessor_name)
        class_eval <<-"end_eval", __FILE__, __LINE__
          def self.#{accessor_name}(*args)
            @@#{accessor_name} = args.first unless args.empty?
            @@#{accessor_name}
          end
        end_eval
      end
  end
end