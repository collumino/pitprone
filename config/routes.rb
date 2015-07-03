Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/supervizor', as: 'rails_admin'
  namespace :api do
    resources :pizzas, except: [:new, :edit, :update, :show]
    patch 'pizzas', to: "pizzas#update"
    patch 'add_ingredient', to: "pizzas#add_item"
    delete 'del_ingredient', to: "pizzas#remove_item"
  end


  delete 'reset', to: 'visitors#destroy_order'
  root to: 'visitors#index'

  devise_for :users
  resources :users
end
