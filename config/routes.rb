Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root "pages#home"
  get "about", to: "pages#about"
  get 'signup', to: "users#new"
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  resources :articles
  resources :users, execept: [:new]
  resources :categories, execept: [:destroy]
end
