$LOAD_PATH << File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'application'
require 'resource_controller/accessors'
require 'resource_controller/action_options'
require 'resource_controller/actions'
require 'resource_controller/base'
require 'resource_controller/class_methods'
require 'resource_controller/controller'
require 'resource_controller/failable_action_options'
require 'resource_controller/helpers'
require 'resource_controller/response_collector'
require 'resource_controller/singleton'
require 'resource_controller/version'
require 'urligence'

module ResourceController
  ACTIONS           = [:index, :show, :new_action, :create, :edit, :update, :destroy].freeze
  SINGLETON_ACTIONS = (ACTIONS - [:index]).freeze
  FAILABLE_ACTIONS  = ACTIONS - [:index, :new_action, :edit].freeze
  NAME_ACCESSORS    = [:model_name, :route_name, :object_name]  
  
  module ActionControllerExtension
    unloadable
    
    def resource_controller(*args)
      include ResourceController::Controller
      
      if args.include?(:singleton)
        include ResourceController::Helpers::SingletonCustomizations
      end
    end  
  end
end

require File.dirname(__FILE__)+'/../rails/init.rb' unless ActionController::Base.include?(Urligence)
