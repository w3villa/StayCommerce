Stay::Engine.routes.draw do
  devise_for :users, class_name: "Stay::User", controllers: {
    registrations: 'stay/users/registrations',
    sessions: 'stay/users/sessions',
    passwords: 'stay/users/passwords'}

  root to: '/'

    namespace :admin do
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
