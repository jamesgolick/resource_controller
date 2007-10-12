require File.dirname(__FILE__)+'/test_helper'

class ActionOptionsTest < Test::Unit::TestCase
  def setup
    @controller     = PostsController.new
    @create = ResourceController::ActionOptions.new
  end
  
  should "have attr accessor for flash" do
    @create.flash = "Successfully created."
    assert_equal "Successfully created.", @create.flash
  end

  %w(before after response).each do |accessor|
    should "have a block accessor for #{accessor}" do
      @create.send(accessor) do
        "return_something"
      end
    
      assert_equal "return_something", @create.send(accessor).call(nil)
    end
  end
end
