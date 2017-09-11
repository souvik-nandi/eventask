Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :events do
    resources :tasks do
      get 'expense'
      get 'completed'
      get 'allocation'
      get 'userallocate'
      get 'userdeallocate'
    end
  end

  resources :allocations
  
  get 'signup', to: 'users#new'
  resources :users, except: [:new] do
    get 'tasks'
    resources :expenses, shallow: true
  end
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
