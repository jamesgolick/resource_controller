class Cms::PhotosController < ResourceController::Base
  actions :all, :except => :update
  
  belongs_to :personel
  create.flash { "#{@photo.title} was created!" }  
end
