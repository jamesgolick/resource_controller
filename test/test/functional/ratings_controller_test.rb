require File.dirname(__FILE__) + '/../test_helper'
require 'ratings_controller'

# Re-raise errors caught by the controller.
class RatingsController; def rescue_action(e) raise e end; end

class RatingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = RatingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @post       = Post.create
    @comment    = @post.comments.create
    @rating     = @comment.ratings.create
  end
  
  context "with post and comment as parents" do
    should_be_restful do |resource|
      resource.formats = [:html]
      resource.parents = [:post, :comment]
    end
    
    context "on get to index" do
      setup do
        @another_comment = Comment.create
        @a_rating_from_another_comment = @another_comment.ratings.create
        get :index, :post_id => @post, :comment_id => @comment
      end

      should "scope ratings to the current comment" do
        assert !assigns(:ratings).include?(@a_rating_from_another_comment), "Ratings are being shown that don't belong to the current post.comment: #{assigns(:ratings).inspect}"
      end
    end
  end
  
end
