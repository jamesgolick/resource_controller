module ResourceController
  class Base < ApplicationController
    include Actions
    include Helpers
  end
end