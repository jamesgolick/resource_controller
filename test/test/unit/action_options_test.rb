require File.dirname(__FILE__)+'/../test_helper'

class ActionOptionsTest < Test::Unit::TestCase
  def setup
    @controller     = PostsController.new
    @create = ResourceController::ActionOptions.new
  end
  
  should "have attr accessor for flash" do
    @create.flash "Successfully created."
    assert_equal "Successfully created.", @create.flash
  end

  %w(before after).each do |accessor|
    should "have a block accessor for #{accessor}" do
      @create.send(accessor) do
        "return_something"
      end
    
      assert_equal "return_something", @create.send(accessor).call(nil)
    end
  end
  
  context "response yielding to response collector" do
    setup do
      @create.response do |wants|
        wants.html
      end
    end

    should "collect responses" do
      assert @create.wants[:html]
    end
    
    should "clear the collector on a subsequent call" do
      @create.response do |wants|
        wants.js
      end
      
      assert_nil @create.wants[:html]
      assert @create.wants[:js]
    end
    
    should "add response without clearing" do
      @create.wants.js
      assert @create.wants[:js]
      assert @create.wants[:html]
    end
  end
end
