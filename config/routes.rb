Rails.application.routes.draw do

  root to: 'users#index'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Global routes for the owner (non-domain-specific)
  resources :hospitals do
    resources :admins, only: [:index, :create, :update, :destroy]
  end

  # Subdomain-specific routes
  constraints subdomain: /.*/ do
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      resources :appointments, only: [:index, :create, :update, :destroy]
      resources :medical_records, only: [:index, :show, :create, :update, :destroy]
    end

    get 'dashboard', to: 'dashboard#index', as: 'hospital_dashboard'
  end
end

