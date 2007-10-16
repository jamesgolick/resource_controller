module ResourceController
  module Helpers
    protected
      def model
        model_name.camelize.constantize
      end
    
      def model_name
        controller_name.singularize.underscore
      end
    
      def collection
        model.find(:all)
      end
    
      def param
        params[:id]
      end
    
      def object
        @object ||= model.find(param)
      end
    
      def load_object
        instance_variable_set "@#{model_name}", object
      end
    
      def load_collection
        instance_variable_set "@#{model_name.pluralize}", collection
      end
    
      def object_params
        params["#{model_name}"]
      end
    
      def build_object
        @object ||= model.new object_params
      end
      
      def collection_url_options
        [model_name.pluralize.to_sym]
      end
      
      def object_url_options
        [object]
      end
      
      def object_url
        smart_url *object_url_options
      end
      
      def collection_url
        smart_url *collection_url_options
      end
      
      def response_for(action)
        respond_to do |wants|
          options_for(action).response.each do |method, block|
            wants.send(method) { instance_eval(&block) }
          end
        end
      end
    
      def after(action)
        block = options_for(action).after
        block.call unless block.nil?
      end
    
      def before(action)
        block = action_options[action].before
        block.call unless block.nil?
      end
    
      def set_flash(action)
        flash[:notice] = options_for(action).flash if options_for(action).flash
      end
    
      def options_for(action)
        action = action == :new_action ? [action] : "#{action}".split('_').map(&:to_sym)
        options = action_options[action.first]
        options = options.send(action.last == :fails ? :fails : :success) if FAILABLE_ACTIONS.include? action.first
      
        options
      end
  end
end