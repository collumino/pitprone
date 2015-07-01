Rails.application.routes.draw do

  namespace :api do
    resources :orders, except: [:new, :edit]
  end

  namespace :admin do
    resources :addresses, except: [:new, :edit]
    resources :pizza_items, except: [:new, :edit]
    resources :pizzas, except: [:new, :edit]
    resources :ingredients, except: [:new, :edit]
    resources :properties, except: [:new, :edit]
  end

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
