require 'test/unit'
require File.dirname(__FILE__)+'/../../../../config/environment.rb'
require 'mocha'
require 'application'
%w(posts_controller post).each { |mock| require File.dirname(__FILE__)+"/mocks/#{mock}" }
