Rails.application.routes.draw do
  get 'users/show'
  get 'chats/index'
  get 'chats/create'
  resources :events do
    get 'daily_schedule', on: :collection
  end

  resources :groups do
    resources :events
    member do
      delete :leave
    end
    post :invite, on: :member
    resources :chats, only: %i[create index]
  end

  get '/join_group/:token', to: 'groups#add_member', as: :join_group
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  get "users/mypage" => "users#show"
  get "users/events_for_date", to: "users#events_for_date", as: :events_for_date
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "tops#index"

  resources :users do
    resources :events, only: [:index]
  end

  resources :notifications, only: %i[index destroy] do
    collection do
      delete "destroy_all"
      get :more_read
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
