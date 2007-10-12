module ResourceController
  module Helpers
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
  end
end