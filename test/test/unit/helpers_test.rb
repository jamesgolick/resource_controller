require File.dirname(__FILE__)+'/../test_helper'

class HelpersTest < Test::Unit::TestCase
  
  def setup
    @controller = PostsController.new

    @params = stub :[] => "1"
    @controller.stubs(:params).returns(@params)

    @object = Post.new
    Post.stubs(:find).with("1").returns(@object)
    
    @collection = mock()
    Post.stubs(:find).with(:all).returns(@collection)
  end
  
  context "model helper" do
    should "return constant" do
      assert_equal Post, @controller.send(:model)
    end
  end
  
  context "collection helper" do
    should "find all" do
      assert_equal @collection, @controller.send(:collection)
    end
  end
  
  context "param helper" do
    should "return the correct param" do
      assert_equal "1", @controller.send(:param)
    end
  end
  
  context "object helper" do    
    should "find the correct object" do
      assert_equal @object, @controller.send(:object)
    end
  end
  
  context "model name helper" do
    should "default to returning the singular name of the controller" do
      assert_equal "post", @controller.send(:model_name)
    end
  end
  
  context "load object helper" do
    setup do
      @controller.send(:load_object)
    end
      
    should "load object as instance variable" do
      assert_equal @object, @controller.instance_variable_get("@post")
    end
  end
  
  context "load_collection helper" do
    setup do
      @controller.send(:load_collection)
    end

    should "load collection in to instance variable with plural model_name" do
      assert_equal @collection, @controller.instance_variable_get("@posts")
    end
  end
  
  context "object params helper" do
    setup do
      @params.expects(:[]).with("post").returns(2)
    end
    
    should "get params for object" do
      assert_equal 2, @controller.send(:object_params)
    end
  end
  
  context "build object helper" do
    context "with no parents" do
      setup do
        Post.expects(:new).with("1").returns("a new post")
      end
    
      should "build new object" do
        assert_equal "a new post", @controller.send(:build_object)
      end
    end
    
    context "with parent" do
      setup do
        @comments_controller = CommentsController.new
        @comment_params = stub()
        @comment_params.stubs(:[]).with(:post_id).returns 2
        @comment_params.stubs(:[]).with('comment').returns ""
        @comments_controller.stubs(:params).returns(@comment_params)
        
        Post.expects(:find).with(2).returns(Post.new)
        @comments = stub()
        @comments.expects(:build).with("").returns("a new comment")
        Post.any_instance.stubs(:comments).returns(@comments)
      end

      should "build new object" do
        assert_equal "a new comment", @comments_controller.send(:build_object)
      end
    end
  end
  
  context "response_for" do
    setup do
      @options = ResourceController::ActionOptions.new
      @options.response {|wants| wants.html}
      @controller.expects(:respond_to).yields(mock(:html => ""))
      @controller.stubs(:options_for).with(:create).returns( @options )
    end

    should "yield a wants object to the response block" do      
      @controller.send :response_for, :create
    end
  end
  
  context "after" do
    setup do
      @options = ResourceController::FailableActionOptions.new
      @options.success.after { }
      @controller.stubs(:options_for).with(:create).returns( @options )
      @nil_options = ResourceController::FailableActionOptions.new      
      @controller.stubs(:options_for).with(:non_existent).returns(@nil_options)
    end

    should "grab the correct block for after create" do
      @controller.send :after, :create
    end

    should "not choke if there is no block" do
      assert_nothing_raised do
        @controller.send :after, :non_existent
      end
    end
  end
  
  context "before" do
    setup do
      @action_options = {:non_existent => ResourceController::ActionOptions.new}

      PostsController.send :cattr_accessor, :action_options
      PostsController.action_options = @action_options
    end
    
    should "not choke if there is no block" do
      assert_nothing_raised do
        @controller.send :before, :non_existent
      end
    end
  end
  
  context "get options for action" do
    setup do
      @action_options = {}
      @action_options[:create] = ResourceController::FailableActionOptions.new
      
      PostsController.send :cattr_accessor, :action_options
      PostsController.action_options = @action_options
    end

    should "get correct object for failure action" do
      assert_equal @action_options[:create].fails, @controller.send(:options_for, :create_fails)
    end
    
    should "get correct object for successful action" do
      assert_equal @action_options[:create].success, @controller.send(:options_for, :create)
    end
    
    should "get correct object for non-failable action" do
      assert_equal @action_options[:index], @controller.send(:options_for, :index)
    end
    
    should "understand new_action to mean new" do
      @action_options[:new_action] = ResourceController::ActionOptions.new
      assert_equal @action_options[:new_action], @controller.send(:options_for, :new_action)
    end
  end
  
  context "*_url_options helpers" do
    setup do
      @products_controller = Cms::ProductsController.new
      
      @products_controller.stubs(:params).returns(@params)

      @product = Product.new
      Product.stubs(:find).with("1").returns(@product)
    end
    
    should "return the correct collection options" do
      assert_equal [nil, :posts], @controller.send(:collection_url_options)
    end
    
    should "return the correct object options" do
      assert_equal [nil, @object], @controller.send(:object_url_options)
    end
    
    should "return the correct collection options for a namespaced controller" do
      assert_equal [:cms, nil, :products], @products_controller.send(:collection_url_options)
    end
    
    should "return the correct object options for a namespaced controller" do
      assert_equal [:cms, nil, @product], @products_controller.send(:object_url_options)
    end
  end
  
  context "parent type helper" do
    setup do
      @comments_controller = CommentsController.new
      @comment_params = stub()
      @comment_params.stubs(:[]).with(:post_id).returns 2
      
      @comments_controller.stubs(:params).returns(@comment_params)
    end

    should "get the params for the current parent" do
      assert_equal :post, @comments_controller.send(:parent_type)
    end
    
    context "with multiple possible parents" do
      setup do
        CommentsController.class_eval do
          belongs_to :post, :product
        end
        
        @comment_params = stub()
        @comment_params.stubs(:[]).with(:product_id).returns 5
        @comment_params.stubs(:[]).with(:post_id).returns nil
        @comments_controller.stubs(:params).returns(@comment_params)
      end

      should "get the params for whatever models are available" do
        assert_equal :product, @comments_controller.send(:parent_type)
      end
    end
    
    context "with no possible parent" do
      should "return nil" do
        assert_nil @controller.send(:parent_type)
      end
    end
  end
  
  context "parent object helper" do
    setup do
      @comments_controller = CommentsController.new
      @comment_params = stub()
      @comment_params.stubs(:[]).with(:post_id).returns 2
      
      @comments_controller.stubs(:params).returns(@comment_params)
      @post = Post.new
      Post.stubs(:find).with(2).returns @post
    end

    should "return post with id 2" do
      assert_equal @post, @comments_controller.send(:parent_object)
    end
  end
end
