module ResourceController
  class ActionOptions
    extend BlockAccessor
    
    attr_accessor :flash
    block_accessor :response, :after, :before
  end
end