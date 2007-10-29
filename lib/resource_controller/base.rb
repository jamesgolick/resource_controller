module ResourceController
  
  # == ResourceController::Base
  # 
  # Inherit from this class to create your RESTful controller.  See the README for usage.
  # 
  class Base < ApplicationController
    unloadable
    
    def self.inherited(subclass)
      super
      subclass.class_eval { include ResourceController::Controller }
    end
  end
end