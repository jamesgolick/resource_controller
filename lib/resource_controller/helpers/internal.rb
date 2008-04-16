# Internal action lifecycle management.
# 
# All of these methods are used internally to execute the options, set by the user in ActionOptions and FailableActionOptions
#
module ResourceController::Helpers::Internal
  protected
    # Used to actually pass the responses along to the controller's respond_to method.
    #
    def response_for(action_name, args={})
      respond_to do |wants|
        options_for(action_name, args).response.each do |method, block|
          if block.nil?
            wants.send(method)
          else
            wants.send(method) { instance_eval(&block) }
          end
        end
      end
    end
  
    # Calls the after callbacks for the action, if one is present.
    #
    def after(action_name)
      invoke_callbacks *options_for(action_name).after
    end
  
    # Calls the before block for the action, if one is present.
    #
    def before(action_name)
      invoke_callbacks *self.class.send(action_name).before
    end
    
    # Sets the flash for the action, if it is present.
    #
    def set_flash(action_name, args={})
      fl = options_for(action_name, args).flash
      flash[:notice] = fl if fl
    end
 
    # Builds the object or collection for the request
    def build(action_name)
      invoke_callbacks *options_for(action_name).build
    end

    # Executes the action block
    def action(action_name)
      invoke_callbacks *options_for(action_name).action
    end
    
    # Returns a list of those exceptions which the call rescues
    def rescues(action_name)
      options_for(action_name).rescues || []
    end

    # Returns the exception caught by rescues, if any
    attr_reader :exception

    # Returns the options for an action, which is a symbol.
    #
    def options_for(action_name, args={})
      args[:failure] = false unless args.has_key? :failure
      options = self.class.send(action_name)
      options = options.send(args[:failure] ? :failure : :success)
      options
    end

    def invoke_callbacks(*callbacks)
      unless callbacks.empty?
        callbacks.select { |callback| callback.is_a? Symbol }.each { |symbol| send(symbol) }
      
        block = callbacks.detect { |callback| callback.is_a? Proc }
        instance_eval &block unless block.nil?
      end
    end 
end
