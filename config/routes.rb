BreezeBot::Application.routes.draw do
  devise_for :members

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  get 'member/:id' => 'admins#member_show'
  get 'car/:id' => 'admins#car_show'
  get 'admin' => 'admins#home'
  post 'check_fleet_utilization' =>'admins#check_fleet_utilization'
  post 'check_reservation_on_date/:car_id' =>'admins#check_reservation'
  post 'end_reservation/:car_id' =>'cars#end_reservation'
  post 'check_in_car' => 'admins#vacate_car'
  post 'check_out_car' => 'admins#occupy_car'
  get "reserve_car" => 'cars#reserve_car'
  get "reserve_car" => 'cars#return_car'
  get "pending_pickup" => 'cars#pending_pickup'
  get "pending_return" => 'cars#pending_return'
  get "return_car" => 'cars#return_car'
  get "driving" => 'cars#occupied'
  get 'find_car' => "cars#find_car"
  get "determine_views" => 'actions#determine_view'
  get 'home' => 'welcome#home'
  root :to => 'welcome#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
