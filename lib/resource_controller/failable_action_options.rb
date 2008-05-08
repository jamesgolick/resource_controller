module ResourceController
  class FailableActionOptions
    extend ResourceController::Accessors
    
    scoping_reader :success, :fails
    alias_method :failure, :fails
    
    block_accessor :before, :build, :action
    
    def initialize
      @success = ActionOptions.new
      @fails   = ActionOptions.new
    end
    
    delegate :flash, :after, :response, :wants, :rescues, :to => :success
  end
end
