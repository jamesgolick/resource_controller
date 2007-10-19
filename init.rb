ActionController::Base.class_eval do
  include Urligence
  helper_method :smart_url
end