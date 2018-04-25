Rails.application.routes.draw do
  root to: 'users#home'

  resources :sessions, only: [:create]
  get '/welcome', to: 'sessions#welcome'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  resources :users, only: [:create, :update, :destroy]
  get '/register', to: 'users#new'
  get '/edit_account', to: 'users#edit'
  get '/edit_payment', to: 'users#edit_payment'
  get '/subscribe', to: 'users#subscribe'
  get '/account', to: 'users#account'
  post '/update_payment', to: 'users#update_payment'
  post '/activate', to: 'users#activate'
  post '/deactivate', to: 'users#deactivate'

  get '/test_cards', to: 'test_cards#index'

  resources :boards, only: [:show]
  resources :cards, only: [:show]
  resources :pictures, only: [:create]

  scope 'api' do
    resources :users, only: [:index, :show]
    resources :boards, only: [:index, :create, :update, :destroy]
    resources :lists, only: [:index, :create, :update, :destroy]
    resources :cards, only: [:index, :create, :update, :destroy]
    resources :comments, only: [:index, :create, :update]
    resources :activities, only: [:index, :create, :update]
    resources :pictures, only: [:index, :destroy]
  end

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  namespace :admin do
    get '/', to: 'options#home'
    resources :users, only: [:index, :destroy]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine, at: '/stripe_events'

  get '*path' => redirect('/')
end
