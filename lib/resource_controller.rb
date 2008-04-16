module ResourceController
  module ActionControllerExtension
    def resource_controller
      include ResourceController::Controller
    end
  end
end
