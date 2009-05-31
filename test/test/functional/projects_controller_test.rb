require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < ActionController::TestCase
  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @project    = projects :one
  end

  should_be_restful do |resource|
    resource.formats = [:html]
  end

  context "on DELETE to :destroy that fails" do
    setup do
      Project.any_instance.stubs(:destroy).returns(false)
      delete :destroy, :id => @project.to_param
    end

    should_respond_with :redirect
    should_redirect_to "project_url(@project)"
  end
end
