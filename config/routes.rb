Rails.application.routes.draw do
  
  resources :topics do # the parent
    resources :posts, except: [:index] # children. #index is no longer an available view since we now list them in the parents #show view
  end
  
  resources :users, only: [:new, :create]
  
  get 'about' => "welcome#about"
  
  post 'users/confirm' => "users#confirm"
  
  root 'welcome#index'

end
