Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  root 'events#index'

  resources :users, only: [ :show ] do
    resources :events
  end
end
