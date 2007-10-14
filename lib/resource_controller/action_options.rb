module ResourceController
  class ActionOptions
    extend ResourceController::Accessors
    
    reader_writer :flash
    block_accessor :response, :after, :before
  end
end