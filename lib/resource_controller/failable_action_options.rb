module ResourceController
  class FailableActionOptions
    extend ResourceController::Accessors
    
    scoping_reader :success, :fails
    block_accessor :before
    
    def initialize
      @success = ActionOptions.new
      @fails   = ActionOptions.new
    end
    
    delegate :flash, :after, :response, :to => :success
  end
end