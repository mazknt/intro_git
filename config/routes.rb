Rails.application.routes.draw do
  root "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/help", to: "static_pages#help"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resource :session, only: [:new, :create, :destroy]
  resources :activate_accounts, only: [:edit]
  resources :reset_passwords, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
