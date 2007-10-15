require File.dirname(__FILE__)+'/../test_helper'

class ResponseCollectorTest < Test::Unit::TestCase
  context "yielding a block to a collector object" do
    setup do
      @collector = ResourceController::ResponseCollector.new
      block = lambda do |wants|
        wants.html {}
        wants.js {}
        wants.xml
      end
      block.call(@collector)
    end

    should "collect responses" do
      assert Proc, @collector.responses[:html].class
      assert Proc, @collector.responses[:js].class
      assert Proc, @collector.responses[:xml].class
    end
  end
end