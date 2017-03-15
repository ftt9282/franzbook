Rails.application.routes.draw do
  root	'users#show'
  devise_for :users
  resources :users, only: [:index, :show] do
    resources :friendships, only: [:index, :create]
  end
  resources :friendships, only: [:update, :destroy]
  resources :posts, only: [:create, :destroy]
end
