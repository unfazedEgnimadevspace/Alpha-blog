Rails.application.routes.draw do
  get 'users/new'
  root "pages#home"
  get "about", to: "pages#about"
  get 'signup', to: "users#new"
  resources :articles
  resources :users, execept: [:new]
end
