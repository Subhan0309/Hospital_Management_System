Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords' 
    },only: [:sessions,:passwords]
  
  root to: 'landing_pages#index'



  constraints subdomain: '' do
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }, only: [:registrations]
    resources :hospitals
  end
  constraints subdomain: /.*/ do
        resources :doctors, only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
          resources :comments, only: [:index, :show, :new, :create,:edit, :update, :destroy]
          member do
            patch :update_availability_status
          end
        end
        resources :patients, only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
           resources :comments, only: [:index, :show, :new, :create,:edit, :update, :destroy]
        end
        resources :users, only: [:index, :show, :edit, :update, :destroy ,:new , :create ] do
            resources :comments, only: [:index, :show, :new, :create,:edit, :update, :destroy]
            resources :appointments, only: [:index, :show,:new, :create, :edit, :update, :destroy] do
              collection do
                get :available_doctors
                delete :delete_all
              end
            end
            resources :medical_records, only: [:index, :show, :new, :create,:edit, :update, :destroy] do
              resources :comments, only: [:index, :show, :new, :create,:edit, :update, :destroy]
              delete 'delete_attachment/:attachment_id', to: 'medical_records#delete_attachment', as: 'delete_attachment'
            end
        end
        # Search route
        resources :hospitals
        get 'dashboard', to: 'hospitals#dashboard', as: 'hospital_dashboard'
        get 'search', to: 'search#index'
        get 'profile', to: 'users#profile', as: 'profile'

        get 'hospital_profile', to: 'hospitals#profile'


        get 'all_appointments' , to: 'appointments#all_appointments' # Route for getting all appointment
        get 'all_medical_records' , to: 'medical_records#all_medical_records' # Route for getting all medical records
        get 'all_comments' , to: 'comments#all_comments' # Route for getting all comments
    end
 end
end