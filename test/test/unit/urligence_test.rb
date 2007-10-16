require File.dirname(__FILE__)+'/../test_helper'

class UrligenceTest < Test::Unit::TestCase  
  def setup
    @controller = PostsController.new
    @tag   = stub(:class => stub(:name => "Tag"), :to_param => 'awesomestuff')
    @photo = stub(:class => stub(:name => "Photo"), :to_param => 1)
  end
  
  def test_should_return_url_for_just_one_object_passed_to_it
    setup_mocks "/photos/#{@photo.to_param}", :photo_path, @photo
    assert_equal @expected_return, @controller.smart_url(@photo)
  end
  
  def test_should_return_url_for_two_objects_passed_to_it
    setup_mocks "/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :tag_photo_path, @tag, @photo
    assert_equal @expected_return, @controller.smart_url(@tag, @photo)
  end
  
  def test_should_accept_namespace_as_first_param
    setup_mocks "/admin/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :admin_tag_photo_path, @tag, @photo
    assert_equal @expected_return, @controller.smart_url(:admin, @tag, @photo)
  end
  
  def test_should_accept_nil_options_anywhere
    setup_mocks "/tags/#{@tag.to_param}/photos/#{@photo.to_param}", :tag_photo_path, @tag, @photo
    assert_equal @expected_return, @controller.smart_url(nil, nil, nil, @tag, nil, @photo, nil)
  end
  
  def test_should_interpret_a_plural_symbol_as_the_last_parameter_to_mean_that_we_want_the_plural_path
    setup_mocks "/tags/#{@tag.to_param}/photos", :tag_photos_path, @tag
    assert_equal @expected_return, @controller.smart_url(@tag, :photos)
  end
  
  def test_should_take_a_plural_symbol_as_the_only_parameter
    setup_mocks "/photos", :photos_path
    assert_equal @expected_return, @controller.smart_url(nil, :photos)
  end
  
  def test_should_accept_a_namespace_with_a_plural
    setup_mocks "/admin/products", :admin_products_path
    assert_equal @expected_return, @controller.smart_url(:admin, :products)
  end
  
  def test_should_accept_only_symbols
    setup_mocks '/admin/products/new', :new_admin_products_path
    assert_equal @expected_return, @controller.smart_url(:new, :admin, :products)
  end
  
  private
    def setup_mocks(expected_return, method, *params)
      @expected_return = expected_return
      @controller.expects(method).with(*params).returns(@expected_return)
    end
end
