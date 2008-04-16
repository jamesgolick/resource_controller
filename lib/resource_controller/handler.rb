module ResourceController
  module Handler
    # This handles all incoming actions, for both collection and member methods.
    # It is called by way of defining actions using the Definer class.
    #
    def handle_action(action_name)
      action_name = :new_action if action_name == :new
      setup  action_name
      before action_name
      # Only execute the action on a non-GET request. This provides safety and also
      # the ability to create a "login" method that both prints the form and handles
      # the login action, but only runs the action code on POST.
      if request.method == :get or action action_name
        after action_name
        set_flash    action_name
        response_for action_name
      else
        set_flash    action_name, :failure => true
        response_for action_name, :failure => true
      end
    rescue Exception => e
      # roundabout way due to Ruby losing special Exception class
      if rescues(action_name).include? e.class
        set_flash    action_name, :failure => true
        response_for action_name, :failure => true
      else
        raise
      end
    end

  end
end
