Rails.application.routes.draw do
  root 'static_pages#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :reports, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :comments, only: [:create, :destroy]
end
