

  # Oauth
  get "oauth/:provider/new"       => "authentications#new",    :as => 'oauth',          :constraints => { :provider => /PROVIDERS_HERE/ }
  get "oauth/:provider/callback"  => "authentications#create", :as => 'oauth_callback', :constraints => { :provider => /PROVIDERS_HERE/ }
  resources :authentications, :only => [:index, :destroy]
  