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
  
  context "with user as parent" do
    context "on get to :index" do
      setup do
        get :index, :user_id => 1
      end

      should_respond_with :success
      should_render_template "index"
      should_assign_to :photos
      should_assign_to :user
      should "scope photos to user" do
        assert assigns(:photos).all? { |photo| photo.user.id == 1 }
      end
    end
    
    context "on post to :create" do
      setup do
        post :create, :user_id => 1, :photo => {}
      end

      should_redirect_to 'user_photo_path(@photo.user, @photo)'
      should_assign_to :photo
      should_assign_to :user
      should "scope photo to user" do
        assert accounts :one, assigns(:photo).user
      end
    end
  end
end
