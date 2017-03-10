Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show] do
    resources :friendships, only: [:index, :create, :update, :destroy]
  end
end
