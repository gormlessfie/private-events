Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  root 'events#index'
  get '/users/', to: 'events#index'

  get '/events/old', to: 'old_events#index'
  get '/events/close', to: 'close_events#index'
  
  resources :events, only: [ :index ]
  resources :users_events, only: [ :new, :create, :destroy ]

  resources :users, only: [ :show ] do
    resources :events, except: [ :index ]
  end
end
