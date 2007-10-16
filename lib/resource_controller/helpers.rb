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
        end_of_association_chain.find(:all)
      end
    
      def param
        params[:id]
      end
    
      def object
        @object ||= end_of_association_chain.find(param)
      end
    
      def load_object
        instance_variable_set "@#{parent_type}", parent_object if parent?
        instance_variable_set "@#{model_name}", object
      end
    
      def load_collection
        instance_variable_set "@#{parent_type}", parent_object if parent?
        instance_variable_set "@#{model_name.pluralize}", collection
      end
    
      def object_params
        params["#{model_name}"]
      end
    
      def build_object
        @object ||= end_of_association_chain.send parent? ? :build : :new, object_params
      end
      
      def end_of_association_chain
        parent? ? parent_association : model
      end
      
      def parent_association
        @parent_association ||= parent_object.send(model_name.pluralize.to_sym)
      end
      
      def parent_type
        @parent_type ||= [*belongs_to].find { |parent| !params["#{parent}_id".to_sym].nil? }
      end
      
      def parent?
        !parent_type.nil?
      end
      
      def parent_param
        params["#{parent_type}_id".to_sym]
      end
      
      def parent_model
        parent_type.to_s.camelize.constantize
      end
      
      def parent_object
        parent? ? parent_model.find(parent_param) : nil
      end
      
      def namespaces
        names = self.class.name.split("::")
        names.pop
        
        names.map(&:downcase).map(&:to_sym)
      end
      
      def collection_url_options
        [namespaces, parent_object, model_name.pluralize.to_sym].flatten
      end
      
      def object_url_options
        [namespaces, parent_object, object].flatten
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