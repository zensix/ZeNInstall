CustomeR::Application.routes.draw do
  
  get "pages/doc"

  get "pages/contact"

  # match "categories",         :to => "categories#index",  :via => "get"
  # match "categories/new",     :to => "categories#new",    :via => "get"
  # match "categories/:id/edit",:to => "categories#edit",   :via => "get"
  # match "categories",         :to => "categories#create", :via => "post"
  # match "categories/:id",     :to => "categories#update", :via => "put"
  # match "categories/:id",     :to => "categories#destroy",:via => "delete"

 
  # match ":controller",           :to => ":controller#index",  :via => "get"
  # match ":controller/new",       :to => ":controller#new",    :via => "get"
  # match ":controller/:id/edit",  :to => ":controller#edit",   :via => "get"
  # match ":controller",           :to => ":controller#create", :via => "post"
  # match ":controller/:id",       :to => ":controller#create", :via => "put"
  # match ":controller/:id",       :to => ":controller#destroy",:via => "delete"

#  match "customers/ajaxsearch",           :to => "customers#ajaxsearch",  :via => "get"
  resources :uploaded_files,:only => [:index, :new, :edit, :create, :update, :destroy]
  resources :categories,:only => [:index, :new, :edit, :create, :update, :destroy]
  resources :countries, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :customers, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :sites, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :familles, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :globalparameters, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :architectures, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :etats, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :ipxescripts, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :systeminstallscripts, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :systems, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :postinstallscripts, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :projectionscripts, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :servers, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :logs, :only => [:index, :new, :edit, :create, :update ]
  
  get "engine/getipxescript"
  get "engine/getosinstallscript"
  get "engine/getpostconfigscript"
  get "engine/setstatusfinish"
  get "engine/getdestinationscript"
  get "engine/getprojectionscript"
  get "engine/getesxiboot"
  get "engine/test"
  
  match '/getpostconfigscript/:uuid', :to => 'engine#getpostconfigscript'
  match '/generatednsfile/:uuid', :to => 'engine#generatednsfile'
  match '/getosinstallscript/:uuid', :to => 'engine#getosinstallscript'
  match '/getosinstalls/:uuid', :to => 'engine#getosinstallscript'
  match '/getipxescript/:uuid',  :to => 'engine#getipxescript'
  match '/setstatusfinish/:uuid',  :to => 'engine#setstatusfinish'
  match '/getesxiboot/:uuid' , :to => 'engine#getesxiboot'
  match '/view_server_ipxescript/:id', :to => 'engine#view_server_ipxescript'
  match '/view_server_osinstallscript/:id', :to => 'engine#view_server_osinstallscript'
  match '/view_server_postinstallscript/:id', :to => 'engine#view_server_postconfigscript'
  match '/getdestinationscript/:uuid', :to => 'engine#getdestinationscript'
  match '/view_destinationscript/:id', :to => 'engine#view_destinationscript'
  match '/view_server_projectionscript/:id', :to => 'engine#view_server_projectionscript'
  match '/engine/test/:id' , :to => 'engine#test'
  match '/test/:id' , :to => 'engine#test'
 
  

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
  root :to => 'dashboard#index', :as => 'dashboard'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
