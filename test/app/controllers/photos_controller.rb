class PhotosController < ResourceController::Base
  actions :all, :except => :update
end
