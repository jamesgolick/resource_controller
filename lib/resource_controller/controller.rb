module ResourceController
  module Controller    
    def self.included(subclass)
      subclass.class_eval do
        include ResourceController::Helpers
        include ResourceController::Actions
        extend  ResourceController::Accessors
        extend  ResourceController::ClassMethods
        
        # these need to behave a little bit differently than the normal class_reader_writers, since they don't pick out the first argument
        # if one exists, because we need to be able to distinguish between an array being passed, and a normal arg
        def self.belongs_to(*args)
          unless args.empty?
            write_inheritable_attribute(:belongs_to, args)
          end
          
          read_inheritable_attribute(:belongs_to)
        end
        
        def belongs_to
          self.class.belongs_to
        end
        
        class_reader_writer *NAME_ACCESSORS
        NAME_ACCESSORS.each { |accessor| send(accessor, controller_name.singularize.underscore) }

        ACTIONS.each do |action|
          class_scoping_reader action, FAILABLE_ACTIONS.include?(action) ? FailableActionOptions.new : ActionOptions.new
        end

        self.helper_method :object_url, :edit_object_url, :new_object_url, :collection_url, :object, :collection, 
                             :parent, :parent_type, :parent_object, :model_name, :model, :object_path, :edit_object_path,
                              :new_object_path, :collection_path, :hash_for_collection_path, :hash_for_object_path, 
                                :hash_for_edit_object_path, :hash_for_new_object_path, :hash_for_collection_url, 
                                  :hash_for_object_url, :hash_for_edit_object_url, :hash_for_new_object_url, :parent?,
                                    :collection_url_options, :object_url_options, :new_object_url_options
                                
      end
      
      init_default_actions(subclass)
    end
        
    private
      def self.init_default_actions(klass)
        klass.class_eval do
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
        end
      end
  end
end