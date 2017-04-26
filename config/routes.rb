Rails.application.routes.draw do
  
  resources :topics do # the parent
    resources :posts, except: [:index] # children. #index is no longer an available view since we now list them in the parents #show view
  end
  
  resources :posts, only: [] do
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
  end
  
  resources :users, only: [:new, :create, :show]
  
  resources :sessions, only: [:new, :create, :destroy]
  
  get 'about' => "welcome#about"
  
  root 'welcome#index'

end
