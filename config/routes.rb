Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post   '/sign-in'       => 'sessions#create'
  delete '/sign-out'      => 'sessions#destroy'

  resource :sessions
  resource :login_tokens, only: %i[create]
  resource :users

  resources :availability_requests
  resources :facilities, only: %i[index] do
    resources :availabilities do
      collection do
        post :import
      end
    end
  end
end
