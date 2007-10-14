module ResourceController
  class ActionOptions
    extend Accessors
    
    reader_writer :flash
    block_accessor :response, :after, :before
  end
end