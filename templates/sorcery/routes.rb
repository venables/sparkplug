# Users, Sessions
  get "logout"  => "sessions#destroy",  :as => "logout"
  get "login"   => "sessions#new",      :as => "login"
  get "signup"  => "users#new",         :as => "signup"
  resources :users
  resources :sessions

  # Forgot Password
  get "forgot-password"     => "password_resets#new",   :as => 'forgot_password'
  get "reset-password/:id"  => "password_resets#edit",  :as => 'reset_password'
  resources :password_resets