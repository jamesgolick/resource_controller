# Nested and Polymorphic Resource Helpers
#
module ResourceController::Helpers::Nested
  protected
    
    # Returns the type of the current parent
    #
    def parent_types
      @parent_types ||= [*belongs_to].reject(&:nil?).
                          map { |parent_type| [*parent_type] }.
                            select { |parent_type| parent_type.all? { |parent| !parent_param(parent).nil? } }.flatten
    end
    
    # Returns true/false based on whether or not a parent is present.
    #
    def parent?
      !parent_types.empty?
    end
    
    # Returns the current parent param, if there is a parent. (i.e. params[:post_id])
    def parent_param(type)
      params["#{type}_id".to_sym]
    end
    
    def parent_objects
      @parent_objects ||= returning [] do |parent_objects|
        parent_types.inject do |last, next_type|
          parent_objects << last = last.to_s.classify.constantize.find(parent_param(last)) if last.is_a? Symbol
          parent_objects << last.send(next_type.to_s.pluralize).find(parent_param(next_type))
        end
      end
    end
    
    # If there is a parent, returns the relevant association proxy.  Otherwise returns model.
    #
    def end_of_association_chain
      parent? ? parent_objects.last.send(model_name.to_s.pluralize.intern) : model
    end
end
