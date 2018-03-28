Rails.application.routes.draw do
  root to: 'home#index'
 
  # delete "/users/sign_out" => "users#destroy"
  devise_for :users, :controllers => {confirmations: 'confirmations',registrations: "users/registrations", sessions: "users/sessions", omniauth_callbacks: 'callbacks',passwords: 'users/passwords' }
  #namespace "api/v1", :as=>:api do
  get "/subscription/news_letter_subscription" => "subscription#news_letter_subscription"
  
  namespace :app do
    namespace :api do

      ###### Admin Api ########################
      namespace :admin do
        
        ################### Dashboards Api #############################
        get "/" => "dashboards#index"
        get '/get_chart_data' => "dashboards#get_chart_data"
        get '/usr_evnt_count'  => "dashboards#usr_event"

        ################### users Api's #################################
        get "listusers" => "users#all_users"
        delete "listusers/:id" => "users#delete_user" , as: "user_delete"
        patch "/users/update" => "users#update"
        get  "/profile" => "users#show", as: "user_profile"
        post '/users_list' => "users#get_users_list"
  	    post  "/users/setting" => "users#edit"
        post  "/users/activeDeactve" => "users#change_status"

        ################### categories Api's ##############################
        get 'categorylist' => "categories#index"
        post 'categories' => "categories#create"
        patch 'categories/:id' => "categories#update"
        delete  'categories/:id' => "categories#destroy"
        post '/category_list' =>"categories#get_category_list"
        get '/categories/:id/edit' => "categories#edit"
        post  "/categories/activeDeactve" => "categories#change_status"
        get 'delete_categories' => 'categories#delete_categories'
        
        ################### Artists Api's  #################################
        resources :artists , :only =>[:index, :create, :update, :destroy, :edit]
        get '/artist_list' =>"artists#get_artist_list"
        post  "/artists/activeDeactve" => "artists#change_status"
        get 'delete_artists' => 'artists#delete_artists'
        
        ################## Events Api's #####################################
        resources :events , :only =>[:index, :create, :update, :show, :edit, :destroy]
        post '/all_event_list' => "events#get_event_list"
        post '/latestEvent' => "events#latest_event"
        post '/event_list/:event_type' => "events#event_list"
        post  "/events/activeDeactve" => "events#change_status"
        get 'delete_events' => 'events#delete_events'
      end

      ###### web Api's ##################
      namespace :web do
        
        ################  Advertise Api ##########################
        resources :advertises, :except =>[:new, :edit]

        ################ Contact Us Api #################################
        resources :contacts, :except =>[:new, :edit, :update]

        ################  Customer Feedback Api ##########################
        post '/customer_feedback' => "contacts#customer_feedback"

        ####################  Event Api #################################
        get '/today_event' => "events#today_event"
        get '/paid_event' => "events#paid_event"
        get '/free_event' => "events#free_event"
        get '/recent_event' => "events#recent_event"
        get '/event_details/:id' => "events#event_details"
        
        ###################  Search Api #################################
        get '/searchevents/' => "search#search"

        
      end
    end
  end
  
end
