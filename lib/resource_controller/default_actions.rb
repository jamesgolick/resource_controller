module ResourceController
  # This module includes default actions, which are based on the default Rails
  # actions of new/edit/destroy. This enables out-of-the-box functionality to
  # mimick Rails' generated controllers. We don't use define_action here
  # because this is handled by the route iteration, and we don't want to
  # create methods for actions that the programmer has removed from routes.rb
  # 
  module DefaultActions
    class << self
      def index(klass)
        klass.index do
          build { load_collection }
          wants.html
          wants.xml  { render :xml => collection }
          failure.wants.html { render :text => "Collection not found.", :status => 404 }
          failure.wants.xml  { head 404 }
        end
      end
      
      def show(klass)
        klass.show do
          build { load_object }
          rescues ActiveRecord::RecordNotFound
          wants.html
          wants.xml  { render :xml => object }
          failure.wants.html { render :text => "Member object not found.", :status => 404 }
          failure.wants.xml  { head 404 }
        end
      end
    
      def new_action(klass)
        klass.new_action do
          build do
            build_object
            load_object
          end
          wants.html
        end
      end
      
      def create(klass)
        klass.create do
          build do
            build_object
            load_object
          end
          action { object.save  }
          flash "Successfully created!"
          wants.html { redirect_to object_url }
          wants.xml  { render :xml => object, :status => :created, :location => object }
          failure.wants.html { render :action => "new" }
          failure.wants.xml  { render :xml => object.errors, :status => :unprocessable_entity }
        end        
      end
      
      def edit(klass)
        klass.edit do
          build { load_object }
          wants.html
        end
      end
      
      def update(klass)
        klass.update do
          build  { load_object }
          action { object.update_attributes object_params }
          flash "Successfully updated!"
          wants.html { redirect_to object_url }
          wants.xml  { head :ok }
          failure.wants.html { render :action => "edit" }
          failure.wants.xml  { render :xml => object.errors, :status => :unprocessable_entity }
        end
      end
     
      def destroy(klass)
        klass.destroy do
          build  { load_object }
          action { object.destroy } 
          flash "Successfully removed!"
          wants.html { redirect_to collection_url }
          wants.xml  { head :ok }
        end
      end
    end # class << self
  end # DefaultActions
end # ResourceController
