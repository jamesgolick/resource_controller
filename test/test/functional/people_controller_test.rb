require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @person     = accounts :one
  end

  should_be_restful do |resource|
    resource.formats = [:html]
    resource.klass   = Account
    resource.object  = :person
    
    resource.create.redirect = 'person_url(@person)'
    resource.update.redirect = 'person_url(@person)'
    resource.destroy.redirect = 'people_url'
  end
  
  context "before create" do
    setup do
      post :create, :person => {}
    end

    should "name account Bob Loblaw" do
      assert_equal "Bob Loblaw", assigns(:person).name
    end
  end

  context "index" do
    setup do
      get :index, :format => :xml
    end

    should_respond_with :success

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the index in XML form" do
      assert_equal Account.find(:all).to_xml, @response.body
    end
  end
  
  context "show" do
    setup do
      get :show, :format => :xml
    end

    should_respond_with :success

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the index in XML form" do
      assert_equal Account.find(:first).to_xml, @response.body
    end
  end
  
  context "on get to new" do
    setup do
      get :new, :format => :xml
    end

    should_respond_with :success

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the index in XML form" do
      assert_equal Account.find(:first).to_xml, @response.body
    end
  end
  
  context "on post to create" do
    setup do
      post :create, :person => {}, :format => :xml
    end

    should_respond_with :created

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the index in XML form" do
      assert_equal assigns(:person).to_xml, @response.body
    end
  end
  
  context "on put to update" do
    setup do
      put :update, :id => 1, :person => {}, :format => :xml
    end

    should_respond_with :ok

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

  end

  context "on destroy" do
    setup do
      post :destroy, :id => 1, :format => :xml
    end

    should_respond_with :ok

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

  end

  context "on put to update fails" do
    setup do
      Account.any_instance.stubs(:save).returns(false)
      put :update, :id => 1, :person => {}, :format => :xml
    end

    should_respond_with :unprocessable_entity

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the errors in XML form" do
      assert_equal assigns(:person).errors.to_xml, @response.body
    end
  end

  context "on post to create fails" do
    setup do
      Account.any_instance.stubs(:save).returns(false)
      post :create, :person => {}, :format => :xml
    end

    should_respond_with :unprocessable_entity

    should "respond with content type application/xml" do
      assert_equal "application/xml", @response.content_type
    end

    should "respond with the errors in XML form" do
      assert_equal assigns(:person).errors.to_xml, @response.body
    end
  end
end
