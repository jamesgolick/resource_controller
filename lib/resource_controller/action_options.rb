module ResourceController
  class ActionOptions
    extend ResourceController::Accessors
    
    reader_writer :flash
    block_accessor :after, :before
    
    def initialize
      @collector = ResourceController::ResponseCollector.new
    end
    
    def response(&block)
      if block_given?
        @collector.clear
        block.call(@collector)
      end
      
      @collector.responses
    end
  end
end