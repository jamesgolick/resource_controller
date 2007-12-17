class RatingsController < ResourceController::Base
  belongs_to [:post, :comment]
end
