module ResourceController
  class Base < ApplicationController
    include ResourceController::Helpers
    include ResourceController::Actions
  end
end