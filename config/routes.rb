Rails.application.routes.draw do
  root to: 'home#index'
	
	
	get  "/users/setting" => "users#edit"
  # delete "/users/sign_out" => "users#destroy"
  devise_for :users, :controllers => {confirmations: 'confirmations',registrations: "users/registrations", sessions: "users/sessions", omniauth_callbacks: 'callbacks' }
  #namespace "api/v1", :as=>:api do
  
  namespace :app do
    namespace :api do
      namespace :admin do
    	get "/"	=> "dashboards#index"

      #users Api's
    	get "listusers"	=> "users#all_users"
    	delete "listusers/:id" => "users#delete_user" , as: "user_delete"
      patch "/users/update" => "users#update"
      get  "/profile/:id" => "users#show", as: "user_profile"

      #categories Api's
      get 'categorylist' => "categories#index"
      post 'categories' => "categories#create"
      patch 'categories/:id' => "categories#update"
      delete  'categories/:id' => "categories#destroy"
      post '/category_list' =>"categories#get_category_list"
      get '/categories/:id/edit' => "categories#edit"
      
      # Artists Api's
      resources :artists , :only =>[:index, :create, :update, :destroy, :edit]
      get '/artist_list' =>"artists#get_artist_list"
      
      # Events Api's
      resources :events , :only =>[:index, :create, :update, :show, :edit, :destroy]
      get '/event_list' => "events#get_event_list"
      end
    end
  end
end
