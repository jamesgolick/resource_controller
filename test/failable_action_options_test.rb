require File.dirname(__FILE__)+'/test_helper'

class FailableActionOptionsTest < Test::Unit::TestCase
  def setup
    @controller = PostsController.new
    @create = ResourceController::FailableActionOptions.new
  end
  
  should "have success and fails" do
    assert ResourceController::ActionOptions, @create.success.class
    assert ResourceController::ActionOptions, @create.fails.class
  end
  
  %w(before).each do |accessor|
    should "have a block accessor for #{accessor}" do
      @create.send(accessor) do
        "return_something"
      end
    
      assert_equal "return_something", @create.send(accessor).call(nil)
    end
  end
  
  should "delegate flash to success" do
    @create.flash = "Successfully created."
    assert_equal "Successfully created.", @create.success.flash
  end
  
  should "delegate after to success" do
    @create.after do
      "something"
    end
    
    assert_equal "something", @create.success.after.call
  end
  
  should "delegate response to success" do
    @create.response do |wants|
      "something"
    end
    
    assert_equal "something", @create.success.response.call(nil)
  end  
  
end