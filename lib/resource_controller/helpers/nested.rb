# Nested and Polymorphic Resource Helpers
#
module ResourceController::Helpers::Nested
  protected
    # Returns the relevant association proxy of the parent. (i.e. /posts/1/comments # => @post.comments)
    #
    def parent_association
      @parent_association ||= parent_object.send(model_name.to_s.pluralize.to_sym)
    end
    
    # Returns the type of the current parent
    #
    def parent_types
      @parent_types ||= [*belongs_to].reject(&:nil?).
                          map { |parent_type| [*parent_type] }.
                            select { |parent_type| parent_type.all? { |parent| !params["#{parent}_id".to_sym].nil? } }.flatten
    end
    
    # Returns true/false based on whether or not a parent is present.
    #
    def parent?
      !parent_types.empty?
    end
    
    # Returns the current parent param, if there is a parent. (i.e. params[:post_id])
    def parent_param
      params["#{parent_types.last}_id".to_sym]
    end
    
    # Like the model method, but for a parent relationship.
    # 
    def parent_model
      parent_types.last.to_s.camelize.constantize
    end
    
    # Returns the current parent object if a parent object is present.
    #
    def parent_object
      parent? ? parent_model.find(parent_param) : nil
    end
    
    # If there is a parent, returns the relevant association proxy.  Otherwise returns model.
    #
    def end_of_association_chain
      parent? ? parent_association : model
    end
end
