Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registations',
                                    sessions: 'users/sessions' }

  root 'events#index'

  resources :events, only: [ :index ]
end
