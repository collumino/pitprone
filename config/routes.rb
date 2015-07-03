Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/supervizor', as: 'rails_admin'
  namespace :api do
    resources :orders, except: [:new, :edit, :update]
    patch 'orders', to: "orders#update"
    patch 'add_ingredient', to: "orders#add_item"
    delete 'del_ingredient', to: "orders#remove_item"
  end

  delete 'reset', to: 'visitors#destroy_order'
  root to: 'visitors#index'

  devise_for :users
  resources :users
end
