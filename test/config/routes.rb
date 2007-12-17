ActionController::Routing::Routes.draw do |map|
  map.resources :ratings

  map.resources :projects

  map.resources :people
  
  map.resources :dudes, :controller => "users"

  map.resources :users do |user|
    user.resources :photos, :name_prefix => "user_"
  end

  map.resources :somethings

  map.resources :photos do |photo|
    photo.resources :tags, :name_prefix => "photo_"
  end
  
  map.resources :tags

  map.resources :products, :name_prefix => "cms_" do |product|
    product.resources :options, :name_prefix => "cms_product_"
  end

  map.resources :posts do |post|
    post.resources :comments, :name_prefix => "post_" do |comment|
      comment.resources :ratings, :name_prefix => "post_comment_"
    end
  end
  
  map.resources :comments

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
