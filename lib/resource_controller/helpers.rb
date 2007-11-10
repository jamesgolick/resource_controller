module ResourceController
  # == ResourceController::Helpers
  #
  # Included in Base.
  # 
  # These helpers are used internally to manage objects, generate urls, and manage parent resource associations.
  #
  # If you want to customize certain controller behaviour, like member-object, and collection fetching, overriding these methods is all it takes.
  #
  # See the docs below, and the README for examples
  #
  # *Please Note: many of these helpers build on top of each other, and require that behaviour to be maintained, in order for other functionality to work properly.*
  # 
  # e.g. All fetching must be done on top of the method end_of_association_chain, or else parent resources (including polymorphic ones) won't function correctly.
  #   
  #   class PostsController < ResourceController::Base
  #   private
  #     def object
  #       @object ||= end_of_association_chain.find_by_permalink(param)
  #     end
  #   end
  module Helpers
    protected
      # Used internally to return the model for your resource.  
      #
      def model
        model_name.camelize.constantize
      end
      
      # Returns the name of the model in underscored form.
      #
      # Defaults to resource_name
      #
      # It is reccomended that you override this method (rather than model), if your controller's name does not follow the pattern ModelNamesController
      #
      def model_name
        resource_name
      end
    
      # Returns the resource name of the model in underscorized form
      # 
      # Used to generate defaults for model_name, and url params. 
      #
      # If you want to change the model name, url name, and variable name all in one shot, override this.
      # 
      def resource_name
        controller_name.singularize.underscore
      end
      
      # Returns the route name
      #
      # This is the name that r_c will use to generate the urls.  If you're using a non-standard controller name, you'll want to override this.
      # 
      # Defaults to resource_name
      #
      def route_name
        resource_name
      end
      
      
      # Returns the singular name of the instance variable should you want to rename it
      # 
      # Defaults to resource_name
      #
      # i.e. When your object is loaded, it is set to @#{object_name}, or the collection to @#{object_name.pluralize}
      #
      def object_name
        resource_name
      end
    
      # Used to fetch the collection for the index method
      #
      # In order to customize the way the collection is fetched, to add something like pagination, for example, override this method.
      #
      def collection
        end_of_association_chain.find(:all)
      end
      
      # Returns the current param.
      # 
      # Defaults to params[:id].
      #
      # Override this method if you'd like to use an alternate param name.
      #
      def param
        params[:id]
      end
    
      # Used to fetch the current member object in all of the singular methods that operate on an existing member.
      #
      # Override this method if you'd like to fetch your objects in some alternate way, like using a permalink.
      #
      # class PostsController < ResourceController::Base
      #   private
      #     def object
      #       @object ||= end_of_association_chain.find_by_permalink(param)
      #     end
      #   end
      #
      def object
        @object ||= end_of_association_chain.find(param)
      end
      
      # Used internally to load the member object in to an instance variable @#{model_name} (i.e. @post)
      #
      def load_object
        instance_variable_set "@#{parent_type}", parent_object if parent?
        instance_variable_set "@#{object_name}", object
      end
      
      # Used internally to load the collection in to an instance variable @#{model_name.pluralize} (i.e. @posts)
      #
      def load_collection
        instance_variable_set "@#{parent_type}", parent_object if parent?
        instance_variable_set "@#{object_name.pluralize}", collection
      end
    
      # Returns the form params.  Defaults to params[model_name] (i.e. params["post"])
      #
      def object_params
        params["#{object_name}"]
      end
      
      # Builds the object, but doesn't save it, during the new, and create action.
      #
      def build_object
        @object ||= end_of_association_chain.send parent? ? :build : :new, object_params
      end
      
      # If there is a parent, returns the relevant association proxy.  Otherwise returns model.
      #
      def end_of_association_chain
        parent? ? parent_association : model
      end
      
      # :section: Nested and Polymorphic Resource Helpers
      
      # Returns the relevant association proxy of the parent. (i.e. /posts/1/comments # => @post.comments)
      #
      def parent_association
        @parent_association ||= parent_object.send(model_name.pluralize.to_sym)
      end
      
      # Returns the type of the current parent
      #
      def parent_type
        @parent_type ||= [*belongs_to].find { |parent| !params["#{parent}_id".to_sym].nil? }
      end
      
      # Returns true/false based on whether or not a parent is present.
      #
      def parent?
        !parent_type.nil?
      end
      
      # Returns the current parent param, if there is a parent. (i.e. params[:post_id])
      def parent_param
        params["#{parent_type}_id".to_sym]
      end
      
      # Like the model method, but for a parent relationship.
      # 
      def parent_model
        parent_type.to_s.camelize.constantize
      end
      
      # Returns the current parent object if a parent object is present.
      #
      def parent_object
        parent? ? parent_model.find(parent_param) : nil
      end
      
      # :section: Url Helpers
      # 
      # Thanks to Urligence, you get some free url helpers.
      # 
      # No matter what your controller looks like...
      # 
      #   [edit_|new_]object_url # is the equivalent of saying [edit_|new_]post_url(@post)
      #   [edit_|new_]object_url(some_other_object) # allows you to specify an object, but still maintain any paths or namespaces that are present
      # 
      #   collection_url # is like saying posts_url
      # 
      # Url helpers are especially useful when working with polymorphic controllers.
      # 
      #   # /posts/1/comments
      #   object_url #=> /posts/1/comments/#{@comment.to_param}
      #   object_url(comment) #=> /posts/1/comments/#{comment.to_param}
      #   edit_object_url #=> /posts/1/comments/#{@comment.to_param}/edit
      #   collection_url #=> /posts/1/comments
      # 
      #   # /products/1/comments
      #   object_url #=> /products/1/comments/#{@comment.to_param}
      #   object_url(comment) #=> /products/1/comments/#{comment.to_param}
      #   edit_object_url #=> /products/1/comments/#{@comment.to_param}/edit
      #   collection_url #=> /products/1/comments
      # 
      #   # /comments
      #   object_url #=> /comments/#{@comment.to_param}
      #   object_url(comment) #=> /comments/#{comment.to_param}
      #   edit_object_url #=> /comments/#{@comment.to_param}/edit
      #   collection_url #=> /comments
      # 
      # Or with namespaced, nested controllers...
      # 
      #   # /admin/products/1/options
      #   object_url #=> /admin/products/1/options/#{@option.to_param}
      #   object_url(option) #=> /admin/products/1/options/#{option.to_param}
      #   edit_object_url #=> /admin/products/1/options/#{@option.to_param}/edit
      #   collection_url #=> /admin/products/1/options
      # 
      # You get the idea.  Everything is automagical!  All parameters are inferred.
      # 
      ['', 'edit_'].each do |type|
        symbol = type.blank? ? nil : type.gsub(/_/, '').to_sym
        
        define_method("#{type}object_url") do |*alternate_object|
          smart_url *object_url_options(symbol, alternate_object.first)
        end
        
        define_method("#{type}object_path") do |*alternate_object|
          smart_path *object_url_options(symbol, alternate_object.first)
        end
        
        define_method("hash_for_#{type}object_url") do |*alternate_object|
          hash_for_smart_url *object_url_options(symbol, alternate_object.first)
        end
        
        define_method("hash_for_#{type}object_path") do |*alternate_object|
          hash_for_smart_path *object_url_options(symbol, alternate_object.first)
        end
      end
      
      def new_object_url
        smart_url *new_object_url_options
      end
      
      def new_object_path
        smart_path *new_object_url_options
      end
      
      def hash_for_new_object_url
        hash_for_smart_url *new_object_url_options
      end
      
      def hash_for_new_object_path
        hash_for_smart_path *new_object_url_options
      end
      
      def collection_url
        smart_url *collection_url_options
      end
      
      def collection_path
        smart_path *collection_url_options
      end
      
      def hash_for_collection_url
        hash_for_smart_url *collection_url_options
      end
      
      def hash_for_collection_path
        hash_for_smart_path *collection_url_options
      end
      
      # Used internally to provide the options to smart_url from Urligence.
      #
      def collection_url_options
        namespaces + [parent_url_options, route_name.pluralize.to_sym]
      end
      
      # Used internally to provide the options to smart_url from Urligence.
      #
      def object_url_options(action_prefix = nil, alternate_object = nil)
        namespaces + [parent_url_options, action_prefix, [route_name.to_sym, alternate_object || object]]
      end
      
      # Used internally to provide the options to smart_url from Urligence.
      #
      def new_object_url_options
        namespaces + [parent_url_options, :new, route_name.to_sym]
      end
      
      def parent_url_options
        parent? ? [parent_type.to_sym, parent_object] : nil
      end
      
      # Returns all of the current namespaces of the current controller, symbolized, in array form.
      #
      def namespaces
        names = self.class.name.split("::")
        names.pop
        
        names.map(&:downcase).map(&:to_sym)
      end
      
      # :section: Internal action lifecycle management.
      # 
      # All of these methods are used internally to execute the options, set by the user in ActionOptions and FailableActionOptions
      #
      
      # Used to actually pass the responses along to the controller's respond_to method.
      #
      def response_for(action)
        respond_to do |wants|
          options_for(action).response.each do |method, block|
            if block.nil?
              wants.send(method)
            else
              wants.send(method) { instance_eval(&block) }
            end
          end
        end
      end
    
      # Calls the after block for the action, if one is present.
      #
      def after(action)
        block = options_for(action).after
        instance_eval &block unless block.nil?
      end
    
      # Calls the before block for the action, if one is present.
      #
      def before(action)
        block = self.class.send(action).before
        instance_eval &block unless block.nil?
      end
      
      # Sets the flash for the action, if it is present.
      #
      def set_flash(action)
        flash[:notice] = options_for(action).flash if options_for(action).flash
      end
      
      # Returns the options for an action, which is a symbol.
      #
      # Manages splitting things like :create_fails.
      #
      def options_for(action)
        action = action == :new_action ? [action] : "#{action}".split('_').map(&:to_sym)
        options = self.class.send(action.first)
        options = options.send(action.last == :fails ? :fails : :success) if FAILABLE_ACTIONS.include? action.first
      
        options
      end
  end
end