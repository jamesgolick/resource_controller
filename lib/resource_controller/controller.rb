module ResourceController
  module Controller    
    def self.included(subclass)
      subclass.class_eval do
        include ResourceController::Helpers
        include ResourceController::Actions
        extend  ResourceController::Accessors
        extend  ResourceController::ClassMethods
        
        class_reader_writer :belongs_to

        cattr_accessor :action_options
        self.action_options ||= {}

        (ResourceController::ACTIONS - ResourceController::FAILABLE_ACTIONS).each do |action|
          class_scoping_reader action, ResourceController::ActionOptions.new
          self.action_options[action] = send action
        end

        ResourceController::FAILABLE_ACTIONS.each do |action|
          class_scoping_reader action, ResourceController::FailableActionOptions.new
          self.action_options[action] = send action
        end

        index.wants.html
        edit.wants.html
        new_action.wants.html

        show do
          wants.html

          failure.wants.html { render :text => "Member object not found." }
        end

        create do
          flash "Successfully created!"
          wants.html { redirect_to object_url }

          failure.wants.html { render :action => "new" }
        end

        update do
          flash "Successfully updated!"
          wants.html { redirect_to object_url }

          failure.wants.html { render :action => "edit" }
        end

        destroy do
          flash "Successfully removed!"
          wants.html { redirect_to collection_url }
        end

        self.helper_method :object_url, :edit_object_url, :new_object_url, :collection_url, :object, :collection, 
                             :parent, :parent_type, :parent_object, :model_name, :model
      end
    end
        
  end
end