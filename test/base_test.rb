require File.dirname(__FILE__)+'/test_helper'
require 'resource_controller/base'

class BaseTest < Test::Unit::TestCase
  def setup
    @controller = ResourceController::Base.new
  end
  
  def test_case_name
    
  end
end
