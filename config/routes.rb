Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :events do
  	resources :tasks do
      get 'completed_toggle'
    end
  end

  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
