Rails.application.routes.draw do
  get 'comment/index'
  post 'comment/create'

  get 'comment/new'

  	  root to: 'home#index'
	#devise_for :users, :controllers => {confirmations: 'confirmations',registrations: "users/registrations", sessions: "users/sessions", omniauth_callbacks: 'callbacks' }

	get  "/profile/:id" => "users#show", as: "user_profile"
	post "/users/update" => "users#update"
	get  "/users/setting" => "users#edit"

	namespace :admin do
	get "/"	=> "dashboards#index"
	get "listusers"	=> "dashboards#all_users"
	delete "listusers/:id" => "dashboards#delete_user" , as: "user_delete"
	 resources :events, :categories, :artists
	end	
end
