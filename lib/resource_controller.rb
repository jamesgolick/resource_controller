module ResourceController
  DEFAULT_ACTIONS = [:new_action, :edit, :show, :index, :create, :update, :destroy]
  
  module ActionControllerExtension
    def resource_controller
      include ResourceController::Controller
    end
  end
end
