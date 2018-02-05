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

      # Artists Api's
      resources :artists , :only =>[:index, :create, :update, :destroy]

      # Events Api's
      resources :events , :only =>[:index, :create, :update, :show, :edit, :destroy]
      end
    end
  end
end
