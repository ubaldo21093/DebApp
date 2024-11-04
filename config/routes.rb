Rails.application.routes.draw do
  resources :portfolios
  devise_for :students, controllers: { 
  registrations: 'students/registrations',
  sessions: 'students/sessions',
  passwords: 'students/passwords' 
}
  
  # Necessary Student routes and  portfolio routes
  resources :students, only: [:index, :show, :edit, :update, :destroy] do
    resource :portfolio, only: [:show, :edit, :update]  # Nesting portfolio under student
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "students#index"
end
