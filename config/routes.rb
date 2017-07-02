Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  as :user do
    post   '/sign-in'       => 'sessions#create'
    delete '/sign-out'      => 'sessions#destroy'
  end

  resources :availability_requests
  resources :facilities, only: %i[index]
end
