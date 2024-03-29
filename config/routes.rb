Rails.application.routes.draw do
  get 'users/show'
  get 'chats/index'
  get 'chats/create'
  resources :events do
    get 'daily_schedule', on: :collection
  end

  resources :groups do
    resources :permits, only: [:create, :destroy]
    member do
      get :permits
      get :new_permit
    end
    resources :events
    resource :group_users, only: [:create, :destroy]
    member do
      delete :leave
    end
    post :invite, on: :member
    resources :chats, only: %i[create index]
  end
  get '/join_group/:token', to: 'groups#add_member', as: :join_group
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions'
  }
  get "users/mypage" => "users#show"
  get "users/events_for_date", to: "users#events_for_date", as: :events_for_date
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "tops#index"
  get 'privacy_policy', to: 'tops#privacy_policy'
  get 'terms_of_use', to: 'tops#terms_of_use'

  resources :users do
    resources :events, only: [:index]
  end

  resources :notifications, only: %i[index destroy] do
    collection do
      delete "destroy_all"
      get :more_read
    end
  end

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
