resources :users, :only => [:index, :show] do
  resources :authentications, :only => [:index, :destroy]
end