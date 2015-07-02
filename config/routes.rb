Rails.application.routes.draw do

  namespace :api do
    resources :orders, except: [:new, :edit, :update]
    patch 'orders', to: "orders#update"
    patch 'add_ingredient', to: "orders#add_item"
    delete 'del_ingredient', to: "orders#remove_item"
  end

  namespace :admin do
    resources :addresses, except: [:new, :edit]
    resources :pizza_items, except: [:new, :edit]
    resources :pizzas, except: [:new, :edit]
    resources :ingredients, except: [:new, :edit]
    resources :properties, except: [:new, :edit]
  end

  delete 'reset', to: 'visitors#destroy_order'
  root to: 'visitors#index'

  devise_for :users
  resources :users
end
