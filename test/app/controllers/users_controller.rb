class UsersController < ResourceController::Base
  private
    def resource_name
      'dude'
    end
    
    def model_name
      'account'
    end
end
