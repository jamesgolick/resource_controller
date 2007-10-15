module ResourceController
  class ResponseCollector
    
    attr_reader :responses
    
    def initialize
      @responses = {}
    end
    
    def method_missing(method_name, *args)
      @responses[method_name] = args.first || lambda {}
    end
  end
end