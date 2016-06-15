Uefa::Application.routes.draw do

  resources :payments

  resources :players

  root :to => 'stats#stats'

  resources :groups

  resources :teams do
    resources :comments
  end

  resources :games do

    member do
      put 'finalize'
      post 'ajax_update_score'
    end

    resources :tips
      member do
        post 'ajax_update_tip'
      end

    resources :comments
  end

  resources :winners_tips

  resources :posts do
    resources :comments
  end

  resources :users do
    
    member do
      put 'clear'
      put 'wine'
      put 'send_email_verification'
      get 'email' # getting the form for the user to provide her email.
      put 'games_display_mode'
    end
    
  end
  
  resources :password_resets

  get   '/signup', :to => 'sessions#signup'
  get   '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'

  get '/email_verifications/:id', :to => 'email_verifications#verify_email'

  get '/instructions', :to => 'instructions#instructions'

  get '/newbulkmail', :to => 'BulkMails#newbulkmail'
  post '/sendbulkmail', :to => 'BulkMails#sendbulkmail'
  get '/reminder_winnerstip', :to => 'BulkMails#reminder_winnerstip'
  get '/reminder_wine', :to => 'BulkMails#reminder_wine'

  get '/getgamebox', :to => 'Games#getgamebox'
  get '/getnewcomments', :to => 'Games#getnewcomments'
  get '/getcommentform', :to => 'Games#getcommentform'
  get '/winnerstipskey', :to => 'WinnersTips#winnerstipskey'


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  

end
