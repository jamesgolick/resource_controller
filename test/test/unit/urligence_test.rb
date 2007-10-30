require File.dirname(__FILE__)+'/../test_helper'
require 'urligence'

class PhotosController
  include Urligence
end

class UrligenceTest < Test::Unit::TestCase  
  def setup
    @controller = PhotosController.new
    @tag   = stub(:class => stub(:name => "Tag"), :to_param => 'awesomestuff')
    @photo = stub(:class => stub(:name => "Photo"), :to_param => 1)
  end
  
  context "with one object" do
    setup do
      setup_mocks "/photos/#{@photo.to_param}", :photo_path, @photo
    end

    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(@photo)
    end
  end
  
  context "with two objects" do
    setup do
      setup_mocks "/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :tag_photo_path, @tag, @photo
    end

    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(@tag, @photo)
    end
  end
  
  context "with a namespace as first param" do
    setup do
      setup_mocks "/admin/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :admin_tag_photo_path, @tag, @photo
    end
    
    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(:admin, @tag, @photo)
    end
  end
  
  context "with many nil options anywhere in the arguments" do
    setup do
      setup_mocks "/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :tag_photo_path, @tag, @photo
    end
    
    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(nil, nil, nil, @tag, nil, @photo, nil)
    end
  end
  
  context "with a symbol as the last parameter" do
    setup do
      setup_mocks "/tags/#{@tag.to_param}/photos", :tag_photos_path, @tag
    end

    should "use that as the last fragment of the url" do
      assert_equal @expected_return, @controller.smart_url(@tag, :photos)
    end
  end
  
  context "with a symbol as the only parameter" do
    setup do
      setup_mocks "/photos", :photos_path
    end

    should "use that as the only url fragment" do
      assert_equal @expected_return, @controller.smart_url(nil, :photos)
    end
  end
  
  context "with a namespace, and a plural symbol" do
    setup do
      setup_mocks "/admin/products", :admin_products_path
    end

    should "call the correct url handler" do
      assert_equal @expected_return, @controller.smart_url(:admin, :products)
    end
  end
  
  context "with only symbols" do
    setup do
      setup_mocks '/admin/products/new', :new_admin_products_path
    end
    
    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(:new, :admin, :products)
    end
  end
  
  context "with array parameters for specifying the names of routes that don't match the class name of the object" do
    setup do
      setup_mocks '/something_tags/1', :something_tag_path, @tag
    end

    should "use the name of the symbol as the url fragment" do
      assert_equal @expected_return, @controller.smart_url([:something_tag, @tag])
    end
  end
  
  context "with array parameters and a namespace" do
    setup do
      setup_mocks '/admin/something_tags/1', :admin_something_tag_path, @tag
    end

    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(:admin, [:something_tag, @tag])
    end
  end
  
  context "with array parameters, a namespace, and an ending symbol" do
    setup do
      setup_mocks '/admin/something_tags/1/photos', :admin_something_tag_photos_path, @tag
    end

    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(:admin, [:something_tag, @tag], :photos)
    end
  end
  
  context "with array parameters, a symbol namespace, and normal model parameters" do
    setup do
      setup_mocks '/admin/something_tags/1/photos/1', :admin_something_tag_photo_path, @tag, @photo
    end

    should "return the correct url" do
      assert_equal @expected_return, @controller.smart_url(:admin, [:something_tag, @tag], @photo)
    end
  end
  
  private
    def setup_mocks(expected_return, method, *params)
      @expected_return = expected_return
      @controller.stubs(method).with(*params).returns(@expected_return)
    end
end
