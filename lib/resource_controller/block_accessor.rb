module ResourceController
  module BlockAccessor
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
  end
end