module ResourceController
  class FailableActionOptions
    extend BlockAccessor
    
    attr_accessor :success, :fails
    block_accessor :before
    
    def initialize
      self.success = ActionOptions.new
      self.fails   = ActionOptions.new
    end
    
    delegate :flash=, :after, :response, :to => :success
  end
end