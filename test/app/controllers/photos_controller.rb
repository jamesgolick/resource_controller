class PhotosController < ResourceController::Base
  actions :all, :except => :update
  
  belongs_to :user
  create.flash { "#{@photo.title} was created!" }
  
  private
    def parent_model_for(type)
      if type == :user
        Account
      else
        super
      end
    end
end
