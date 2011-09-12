devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" } do
  get "/users/auth/:provider" => "users/omniauth_callbacks#passthru"
end