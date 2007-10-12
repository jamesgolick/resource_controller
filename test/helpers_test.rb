require File.dirname(__FILE__)+'/test_helper'
require 'resource_controller/helpers'

class HelpersTest < Test::Unit::TestCase
  
  def setup
    @controller = PostsController.new

    @params = stub :[] => "1"
    @controller.stubs(:params).returns(@params)

    @object = Post.new
    Post.stubs(:find).with("1").returns(@object)
    
    @collection = mock()
    Post.stubs(:find).with(:all).returns(@collection)
  end
  
  context "model helper" do
    should "return constant" do
      assert_equal Post, @controller.model
    end
  end
  
  context "collection helper" do
    should "find all" do
      assert_equal @collection, @controller.collection
    end
  end
  
  context "param helper" do
    should "return the correct param" do
      assert_equal "1", @controller.param
    end
  end
  
  context "object helper" do    
    should "find the correct object" do
      assert_equal @object, @controller.object
    end
  end
  
  context "model name helper" do
    should "default to returning the singular name of the controller" do
      assert_equal "post", @controller.model_name
    end
  end
  
  context "load collection" do
    setup do
      @controller.load_object
    end
      
    should "load object as instance variable" do
      assert_equal @object, @controller.instance_variable_get("@post")
    end
  end
  
  context "load_collection helper" do
    setup do
      @controller.load_collection
    end

    should "load collection in to instance variable with plural model_name" do
      assert_equal @collection, @controller.instance_variable_get("@posts")
    end
  end
end
