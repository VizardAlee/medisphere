Rails.application.routes.draw do
  get  '/login',  to: 'shared_sessions#new',     as: :login
  post '/login',  to: 'shared_sessions#create'
  delete '/logout', to: 'shared_sessions#destroy', as: :logout

  devise_for :patients,
    skip: [:registrations, :passwords, :confirmations],  # or skip what you want
    controllers: {
      sessions: "patients/sessions"
    }

  devise_for :users, controllers: { registrations: "users/registrations" }
  # devise_for :patients

  resources :staffs

  resources :users, only: [:show]

  resources :organizations

  resources :patients, only: [:new, :create, :index, :show, :edit, :update] do
    resources :health_records, only: %i[index show]
  end

  resources :health_records, only: [:new, :create, :index, :show, :edit, :update, :destroy]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  devise_scope :patient do
    authenticated :patient do
      root to: "patients#show", as: :authenticated_patient_root
    end
  end

  # get 'staff/dashboard', to: 'staffs#dashboard', as: :staff_dashboard

  unauthenticated do
    root to: "home#index"
  end

  resources :emergency_records, only: [:show] do
    collection do
      get :search
    end
  end

  resources :emergency_respondents, only: [:new, :create] do
    get 'register/:token', to: 'emergency_respondents#new', as: :register
  end  

  namespace :admin do
    get "emergency_respondents/index"
    get "emergency_respondents/update"
    resources :emergency_respondents, only: [:index, :update]
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
