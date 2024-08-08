Rails.application.routes.draw do


  devise_for :users, controllers: {
      sessions: 'users/sessions'
    },only: [:sessions]

  constraints subdomain: '' do
   
  
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }, only: [:registrations]
  
    resources :hospitals
  end
  constraints subdomain: /.*/ do
   
      resources :users,only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
        resources :appointments, only: [:index, :create, :update, :destroy]
        resources :medical_records, only: [:index, :show, :create, :update, :destroy]
      end
      get 'dashboard', to: 'hospitals#dashboard', as: 'hospital_dashboard'
    end

  
 root to: 'landing_pages#index'
end





