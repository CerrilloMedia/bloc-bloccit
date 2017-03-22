Rails.application.routes.draw do
  
  resources :topics do # the parent
    resources :posts, except: [:index] # children. #index is no longer an available view since we now list them in the parents #show view
  end
  
  get 'about' => "welcome#about"
  
  root 'welcome#index'

end
