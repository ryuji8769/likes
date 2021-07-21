Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create] do
    resources :likes, only: [:create, :destroy]
  end

  #通知のルーティング
  resources :notifications, only: :index
  #ここまで

  root 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
