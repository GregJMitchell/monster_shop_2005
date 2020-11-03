Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id", to: "cart#modify_quantity"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  #get "/orders/:id", to: "orders#show"


  namespace :merchant do
    get "/", to: "dashboard#show"
    get "/items", to: "items#index"
  end

  namespace :admin do
    resources :merchants, only: [:index]
    patch '/merchants/disable', to: "merchants#disable"
    patch '/merchants/enable', to: "merchants#enable"
    get '/', to: "dashboard#index"
    get '/users/:id', to: "users#show"
    patch '/:order_id', to: "profile_orders#update"
    get '/merchants/:merchant_id', to: 'merchants#show'
  end

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  get "/profile", to: "users_dashboard#show"
  get "/profile/edit", to: "users_dashboard#edit"
  patch "/profile", to: "users_dashboard#update"

  get '/profile/orders', to: "profile_orders#index"
  get '/profile/orders/:id', to: "profile_orders#show"
  patch "/profile/orders/:id", to: "profile_orders#cancel"

  get "/password/edit", to: "passwords#edit"
  patch "/password", to: "passwords#update"



  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: 'sessions#destroy'

end
