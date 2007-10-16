require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @photo      = Photo.find 1
  end

  context "actions specified" do
    should "not respond to update" do
      assert !@controller.respond_to?(:update)
    end
  end
  
  should_be_restful do |resource|
    resource.formats = [:html]
    
    resource.actions = [:index, :new, :create, :destroy, :show, :edit]
  end
end
