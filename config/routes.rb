Rails.application.routes.draw do
  resources :events do
    get 'daily_schedule', on: :collection
  end

  resources :groups do
    resources :events
    post :invite, on: :member
  end

  get '/join_group/:token', to: 'groups#add_member', as: :join_group
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "tops#index"

  resources :users do
    resources :events, only: [:index]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
