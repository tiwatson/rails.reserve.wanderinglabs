Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post   '/sign-in'       => 'sessions#create'
  delete '/sign-out'      => 'sessions#destroy'

  resource :sessions
  resource :login_tokens, only: %i[create]
  resource :users
  resources :payments, only: %i[create]

  resources :availability_imports
  resources :availability_requests do
    resources :availability_matches, only: %i[index]
  end

  resources :availability_matches, only: [] do
    member do
      post :click
    end
  end

  resources :facilities, only: %i[index] do
    resources :availabilities do
      collection do
        post :import
      end
    end
    resources :sites, only: %i[index]
    member do
      get :grouped_availabilities
    end
  end
end
