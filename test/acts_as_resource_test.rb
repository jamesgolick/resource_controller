require 'test/unit'
require File.dirname(__FILE__)+'/../../../../config/environment.rb'
require 'application'

class ActsAsResourceTest < Test::Unit::TestCase
  should "Instantiate ResourceController" do
    ResourceController.new
  end
end
