Stay::Engine.routes.draw do
  devise_for :users, class_name: "Stay::User", controllers: {
    registrations: 'stay/users/registrations',
    sessions: 'stay/users/sessions',
    passwords: 'stay/users/passwords'}

  namespace :admin do
    devise_for :users,
              class_name: "Stay::User",
              controllers: { sessions: 'stay/admin/sessions',
                                passwords: 'stay/admin/passwords' },
              skip: [:unlocks, :omniauth_callbacks, :registrations],
              path_names: { sign_out: 'logout' }

    devise_scope :user do
      get '/authorization_failure', to: 'sessions#authorization_failure', as: :unauthorized
      get '/login' => 'sessions#new', :as => :login
      post '/login' => 'sessions#create', :as => :create_new_session
      get '/logout' => 'sessions#destroy', :as => :logout
      get '/password/recover' => 'passwords#new', :as => :recover_password
      post '/password/recover' => 'passwords#create', :as => :reset_password
      get '/password/change' => 'passwords#edit', :as => :edit_password
      put '/password/change' => 'passwords#update', :as => :update_password
    end

    get '/', to: 'dashboard#index'
    resources :addresses
    resources :roles
    resources :users
    resources :properties
    resources :rooms
    resources :bookings
    resources :payment_methods
    resources :payments
    resources :reviews
    resources :chats
    resources :messages
  end

  namespace :api do
    namespace :v1 do
      resources :properties, only: [:index, :show] do
        resources :rooms, only: [:index, :show] do
          resources :bookings, only: [:create, :show, :update]
        end
      end
      
      resources :profiles , only: [:show, :update]
    end
  end

end
