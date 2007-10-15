module ResourceController
  class ResponseCollector
    
    attr_reader :responses
    
    delegate :clear, :to => :responses
    
    def initialize
      @responses = {}
    end
    
    def method_missing(method_name, &block)
      @responses[method_name] = block || lambda {}
    end
  end
end