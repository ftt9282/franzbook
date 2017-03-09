Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :friendships, only: [:create, :update, :destroy]
end
