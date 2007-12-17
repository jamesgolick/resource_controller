class PhotosController < ResourceController::Base
  actions :all, :except => :update
  
  belongs_to :user
  
  private
    def parent_model_for(type)
      if type == :user
        Account
      else
        super
      end
    end
end
