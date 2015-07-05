Rails.application.routes.draw do

  namespace :api do
    resources :pizzas, except: [:new, :edit, :update, :show]
    get 'prepare', to: "pizzas#check_orderable"
    patch 'pizzas', to: "pizzas#update"
    patch 'add_ingredient', to: "pizzas#add_item"
    delete 'del_ingredient', to: "pizzas#remove_item"
  end

  get '/supervizor/order/:id/process', to: 'visitors#start'
  get '/supervizor/order/:id/deliver', to: 'visitors#finish'
  get '/supervizor/order/:id/pdf', to: 'visitors#download'

  get 'thank_you', to: 'visitors#thank_you'
  patch 'confirm', to: 'visitors#confirm_verified_order'
  delete 'reset', to: 'visitors#destroy_order'
  root to: 'visitors#index'

  devise_for :users
  mount RailsAdmin::Engine => '/supervizor', as: 'rails_admin'
end
