module ResourceController
  class ActionOptions
    extend BlockAccessor
    
    reader_writer :flash
    block_accessor :response, :after, :before
  end
end