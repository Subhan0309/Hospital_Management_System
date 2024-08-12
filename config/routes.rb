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
    resources :doctors, only: [:index, :show, :edit, :update, :destroy ,:new , :create ]
    resources :patients, only: [:index, :show, :edit, :update, :destroy ,:new , :create ]
    resources :users, only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
      resources :appointments, only: [:index, :show,:new, :create, :edit, :update, :destroy]
      resources :medical_records, only: [:index, :show, :new, :create,:edit, :update, :destroy] do
        resources :comments, only: [:index, :show, :new, :create,:edit, :update, :destroy]
      end
   
    end
    

  
 root to: 'landing_pages#index'
end





