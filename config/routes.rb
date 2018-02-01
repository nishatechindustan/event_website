Rails.application.routes.draw do
  get 'comment/index'
  post 'comment/create'

  get 'comment/new'

  root to: 'home#index'

	get  "/profile/:id" => "users#show", as: "user_profile"
	post "/users/update" => "users#update"
	get  "/users/setting" => "users#edit"
  # delete "/users/sign_out" => "users#destroy"
  devise_for :users, :controllers => {confirmations: 'confirmations',registrations: "users/registrations", sessions: "users/sessions", omniauth_callbacks: 'callbacks' }
#namespace "api/v1", :as=>:api do
  namespace :app do
    namespace :api do
      namespace :admin do
      	get "/"	=> "dashboards#index"
      	get "listusers"	=> "dashboards#all_users"
      	delete "listusers/:id" => "dashboards#delete_user" , as: "user_delete"
        #get 'events' => "event#index"
        get 'categorylist' => "categories#index"
        post 'categories' => "categories#create"
        patch 'categories/:id' => "categories#update"
        delete  'categories/:id' => "categories#destroy"
        resources :artists , :only =>[:index, :create, :update, :destroy]
        resources :events , :only =>[:index, :create, :update, :show, :edit, :destroy]
      end
    end
  end
end
