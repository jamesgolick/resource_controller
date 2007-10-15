module ResourceController
  class Base < ApplicationController
    include ResourceController::Helpers
    include ResourceController::Actions
    extend  ResourceController::Accessors
    
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
        
        index.response do |wants|
          wants.html
        end
        
        edit.response do |wants|
          wants.html
        end
        
        new_action.response do |wants|
          wants.html
        end
        
        show do
          response do |wants|
            wants.html
          end
        end
        
        create do
          flash "Successfully created!"
          response do |wants|
            wants.html { redirect_to send("#{model_name}_path", object) }
          end
          
          fails do
            response do |wants|
              wants.html { render :action => "new" }
            end
          end  
        end
        
        update do
          flash "Successfully updated!"
          response do |wants|
            wants.html { redirect_to send("#{model_name}_path", object) }
          end
          
          fails do
            response do |wants|
              wants.html { render :action => "edit" }
            end
          end
        end
        
        destroy do
          flash "Successfully removed!"
          response do |wants|
            wants.html { redirect_to send("#{model_name.pluralize}_path") }
          end
        end
        
      end
                
    end
  end
end