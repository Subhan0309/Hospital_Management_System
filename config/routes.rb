Rails.application.routes.draw do

  root to: 'landing_pages#index'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  resources :hospitals do
    resources :admins, only: [:index, :create, :update, :destroy]
  end

  # Subdomain-specific routes
  constraints subdomain: /.*/ do
  
    resources :users, only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
      resources :appointments, only: [:index, :create, :update, :destroy]
      resources :medical_records, only: [:index, :show, :create, :update, :destroy]
    end

    get 'dashboard', to: 'hospitals#dashboard', as: 'hospital_dashboard'
  end
 
end

