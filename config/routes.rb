Rails.application.routes.draw do
   
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new"
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  
  resources :patients do
    collection do
      get 'upcoming'
    end
  end
end
