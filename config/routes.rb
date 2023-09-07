Rails.application.routes.draw do
  devise_for :users

  root "sanctionable_entities#index"
  
  resources :sanctionable_entities
  resources :users, only: [:index]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sanctions, only: [] do
        collection { post :check_persons }
      end
    end
  end
end
