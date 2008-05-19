module ResourceController
  class ActionOptions
    extend ResourceController::Accessors
    
    reader_writer  :flash
    block_accessor :after, :before
    
    def initialize
      @collector = ResourceController::ResponseCollector.new
    end
    
    def response(*args, &block)
      if !args.empty? || block_given?
        @collector.clear
        args.flatten.each { |symbol| @collector.send(symbol) }
        block.call(@collector) if block_given?
      end
      
      @collector.responses
    end
    alias_method :respond_to,  :response
    alias_method :responds_to, :response
    
    def wants
      @collector
    end
    
    def dup
      returning self.class.new do |duplicate|
        duplicate.instance_variable_set(:@collector, wants.dup)
        duplicate.instance_variable_set(:@before, before.dup)
        duplicate.instance_variable_set(:@after, after.dup)
        duplicate.instance_variable_set(:@flash, flash.dup)
      end
    end
  end
end