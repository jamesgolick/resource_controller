module ResourceController
  module Definer
    # This is the main definer method, which is called when iterating through the routes.
    # It creates a stub method which then dispatches to Handler.handle_action when the
    # action is called. In addition, it includes logic to setup the correct build
    # pattern, depending on whether it's a collection or member action.
    #
    def define_route_action(route)
      action_name = route.requirements[:action].to_sym
      define_action(action_name)  # def new/create/etc

      action_name = :new_action if action_name == :new
      class_scoping_reader action_name, FailableActionOptions.new unless respond_to? action_name

      #logger.debug "DEFINE: #{action_name}: #{route.inspect}" if action_name == :coll

      assign_default_callbacks(action_name, route.significant_keys.include?(:id) || action_name == :new_action)
    end

    # This creates a hook in the controller so that handle_action will be called on request
    def define_action(action_name)
      define_method(action_name) do
        handle_action(action_name)
      end
    end
    
    # Determine whether this is a member action (has :id) or collection action
    # Note that we can't auto-detect new() in this manner, due to limitations
    # in the information that Rails stores about routes.
    #
    def assign_default_callbacks(action_name, is_member=false)
      DefaultActions.send(action_name, self) if ResourceController::DEFAULT_ACTIONS.include?(action_name)
      # if is_member
      #   send(action_name).build { load_object }
      #   send(action_name).wants.html
      #   send(action_name).wants.xml  { render :xml => object }
      #   send(action_name).failure.flash "Request failed"
      #   send(action_name).failure.wants.html
      #   send(action_name).failure.wants.xml { render :xml => object.errors }
      # else
      #   send(action_name).build { load_collection }
      #   send(action_name).wants.html
      #   send(action_name).wants.xml  { render :xml => collection }
      #   send(action_name).failure.flash "Request failed"
      #   send(action_name).failure.wants.html
      #   send(action_name).failure.wants.xml { head 500 }
      # end
    end

    # Assign a default response block so that the request works automatically.
    #
    def assign_default_response(action_name, has_format=false)
    end
  end
end
