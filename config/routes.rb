Stay::Engine.routes.draw do
  devise_for :users, class_name: "Stay::User", controllers: {
    registrations: 'stay/users/registrations',
    sessions: 'stay/users/sessions',
    passwords: 'stay/users/passwords'}

  namespace :admin do
    root to: 'home#index'

    get '/', to: 'dashboard#index'
    resources :addresses
    resources :roles
    resources :users do
      member do
        get :addresses
        put :addresses
      end
    end
    resources :properties
    resources :rooms
    resources :bookings
    resources :payment_methods
    resources :payments
    resources :reviews
    resources :chats
    resources :messages
    resources :countries do
      member do
        get :states
      end
    end
    resources :states, only: [] do
      member do
        get :cities
      end
    end
    devise_for :users,
              class_name: "Stay::User",
              controllers: { sessions: 'stay/admin/sessions',
                                passwords: 'stay/admin/passwords',
                                 registrations: 'stay/admin/registrations'},
              skip: [:unlocks, :omniauth_callbacks],
              path_names: { sign_out: 'logout' }

    devise_scope :user do
      get '/authorization_failure', to: 'sessions#authorization_failure', as: :unauthorized
      get '/login' => 'sessions#new', :as => :login
      post '/login' => 'sessions#create', :as => :create_new_session
      delete '/logout' => 'sessions#destroy', :as => :logout
      get 'sign_up', to: 'registrations#new', as: :new_registration
      post 'sign_up', to: 'registrations#create', as: :registration
      get '/password/new', to: 'passwords#new', as: :new_password
      post '/password', to: 'passwords#create', as: :password
      get '/password/edit', to: 'passwords#edit', as: :edit_password
      put '/password', to: 'passwords#update'
      patch '/password', to: 'passwords#update'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :properties, only: [:index, :show] do

        collection do
          get 'search', to: 'properties#search'
        end

        resources :rooms, only: [:index, :show] do
          resources :bookings, only: [:create, :show, :update]
        end
      end
      
      resources :profiles , only: [:show, :update]
    end
  end
  
  root 'properties#index'
  resources :properties, only: [:index, :show]  
  resources :profiles , only: [:show, :update]

end
