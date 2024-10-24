Stay::Engine.routes.draw do
  devise_for :users, class_name: "Stay::User", controllers: {
    registrations: "stay/users/registrations",
    sessions: "stay/users/sessions",
    passwords: "stay/users/passwords" }

  namespace :admin do
    root to: "home#index"

    get "/", to: "dashboard#index"
    resources :addresses
    resources :roles
    resources :users do
      member do
        get :addresses
        put :addresses
      end
    end
    resources :properties do
      member do
        put :approve
        put :reject
        put :resubmit
      end
      resources :rooms
    end
    resources :rooms
    resources :bookings
    resources :payment_methods
    resources :payments
    resources :reviews
    resources :chats
    resources :messages
    resources :room_types
    resources :property_categories
    resources :property_types
    resources :bed_types
    resources :amenities
    resources :amenity_categories
    resources :house_rules
    resources :features
    resources :taxes
    resources :countries do
      resources :states
    end
    resources :states, only: [] do
      resources :cities
    end
    resources :stores do
      member do
        put :set_default
      end
    end
    devise_for :users,
              class_name: "Stay::User",
              controllers: { sessions: "stay/admin/sessions",
                            passwords: "stay/admin/passwords",
                              registrations: "stay/admin/registrations",
                            tokens: "customers/api/tokens" },
              skip: [ :unlocks, :omniauth_callbacks ],
              path_names: { sign_out: "logout" }

    devise_scope :user do
      get "/authorization_failure", to: "sessions#authorization_failure", as: :unauthorized
      get "/login" => "sessions#new", :as => :login
      post "/login" => "sessions#create", :as => :create_new_session
      delete "/logout" => "sessions#destroy", :as => :logout
      get "sign_up", to: "registrations#new", as: :new_registration
      post "sign_up", to: "registrations#create", as: :registration
      get "/password/new", to: "passwords#new", as: :new_password
      post "/password", to: "passwords#create", as: :password
      get "/password/edit", to: "passwords#edit", as: :edit_password
      put "/password", to: "passwords#update"
      patch "/password", to: "passwords#update"
    end
  end

  namespace :api do
    namespace :v1 do
      resources :property_categories,  only: [ :index, :show ]
      resources :amenity_categories, only: [ :index ]
      resources :property_types,  only: [ :index, :show ]
      resources :room_types,  only: [ :index, :show ]
      resources :users, only: [ :destroy ]
      resources :house_rules, only: :index
      resources :credit_cards
      resources :user_paypal
      resources :property_features do
        collection do
          get :property
          get :room
        end
      end
      resources :chats, only: [ :index, :create, :show ] do
        collection do
          get :user_chat
        end
        member do
          get "chat_messages", to: "chats#chat_messages"
        end
        resources :messages, only: [ :index, :new, :create ]
      end
      resources :properties, only: [ :index, :show, :create, :update ] do
        collection do
          get "search", to: "properties#search"
        end
        member do
          put :resubmit
        end
        resources :rooms, only: [ :index, :show ] do
          resources :bookings, only: [ :create, :show, :update ] do
            resources :payments, only: [ :new, :create ] do
              collection do
                post :confirm
              end
            end
          end
        end
      end
      resources :profiles, only: [ :show, :update ]
      resources :taxes, only: [ :index ]
    end
  end

  root "properties#index"
  resources :properties, only: [ :index, :show ] do
    resources :bookings, only: [ :new, :create, :show, :update ] do
      resources :payments, only: [ :new, :create ] do
        collection do
          post :confirm
        end
      end
    end
  end

  resources :profiles, only: [ :show, :update ]
end
