module ResourceController
  # This module includes default actions, which are based on the default Rails
  # actions of new/edit/destroy. This enables out-of-the-box functionality to
  # mimick Rails' generated controllers. We don't use define_action here
  # because this is handled by the route iteration, and we don't want to
  # create methods for actions that the programmer has removed from routes.rb
  # 
  module DefaultActions
    def self.included(subclass)
      subclass.class_eval do
        if respond_to? :index
          index do
            build { load_collection }
            wants.html
            wants.xml  { render :xml => collection }
            failure.wants.html { render :text => "Collection not found.", :status => 404 }
            failure.wants.xml  { head 404 }
          end
        end

        if respond_to? :show
          show do
            build { load_object }
            rescues ActiveRecord::RecordNotFound
            wants.html
            wants.xml  { render :xml => object }
            failure.wants.html { render :text => "Member object not found.", :status => 404 }
            failure.wants.xml  { head 404 }
          end
        end

        if respond_to? :new_action
          new_action do
            build { build_object }
            wants.html
          end
        end

        if respond_to? :create
          create do
            build  { build_object }
            action { object.save  }
            flash "Successfully created!"
            wants.html { redirect_to object_url }
            wants.xml  { render :xml => object, :status => :created, :location => object }
            failure.wants.html { render :action => "new" }
            failure.wants.xml  { render :xml => object.errors, :status => :unprocessable_entity }
          end
        end

        if respond_to? :edit
          edit do
            build { load_object }
            wants.html
          end
        end

        if respond_to? :update
          update do
            build  { load_object }
            action { object.update_attributes object_params }
            flash "Successfully updated!"
            wants.html { redirect_to object_url }
            wants.xml  { head :ok }
            failure.wants.html { render :action => "edit" }
            failure.wants.xml  { render :xml => object.errors, :status => :unprocessable_entity }
          end
        end

        if respond_to? :destroy
          destroy do
            build  { load_object }
            action { object.destroy } 
            flash "Successfully removed!"
            wants.html { redirect_to collection_url }
            wants.xml  { head :ok }
          end
        end

      end
    end
  end
end
