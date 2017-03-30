Rails.application.routes.draw do
  root	'users#show'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, only: [:index, :show] do
    resources :friendships, only: [:index, :create]
  end
  resources :friendships, only: [:update, :destroy]
  resources :posts, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
end
