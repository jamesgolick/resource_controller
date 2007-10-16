module ResourceController
  class Base < ApplicationController
    include ResourceController::Helpers
    include ResourceController::Actions
    extend  ResourceController::Accessors
    include Urligence
    
    helper_method :smart_url
    
    def self.inherited(subclass)
      super
      
      subclass.class_eval do
        
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
        
      end
                
    end
  end
end