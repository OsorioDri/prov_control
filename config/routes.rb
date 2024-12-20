Rails.application.routes.draw do
  devise_for :users
  # get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "pages#home"

  get "states", to: "states#index"
  resources :batches

  resources :providers do
    resources :phones, only: [:new, :create]
  end

  resources :phones, only: [:destroy]

  resources :municipalities 
  
  get 'meus_municipios', to: 'municipalities#meus_municipios'
end
