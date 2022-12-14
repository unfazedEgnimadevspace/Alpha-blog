Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'users/new'
  root "pages#home"
  get "about", to: "pages#about"
  get 'signup', to: "users#new"
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :articles
  resources :users, execept: [:new]
  resources :categories, execept: [:destroy]
  resources :account_activations, only: [:edit]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets, only:[ :new, :create, :edit, :update ]

end
