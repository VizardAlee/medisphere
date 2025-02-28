Rails.application.routes.draw do
  # Authentication Routes
  get '/login', to: 'shared_sessions#new', as: :login
  post '/login', to: 'shared_sessions#create'

  # Devise for Patients (Limited)
  devise_for :patients,
             skip: [:registrations, :passwords, :confirmations],
             controllers: {
               sessions: "patients/sessions"
             }

  # Devise for Users (Full)
  devise_for :users, controllers: { registrations: "users/registrations" }

  # Resource Routes
  resources :staffs
  resources :users, only: [:show]
  resources :organizations

  # Patients and Health Records
  resources :patients, only: [:new, :create, :index, :show, :edit, :update] do
    resources :health_records, only: %i[index show]
  end

  resources :health_records, only: [:new, :create, :index, :show, :edit, :update, :destroy]

  # Authenticated Routes
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  devise_scope :patient do
    authenticated :patient do
      root to: "patients#show", as: :authenticated_patient_root
    end
  end

  # Unauthenticated Root
  unauthenticated do
    root to: "home#index"
  end

  # Emergency Records
  resources :emergency_records, only: [:show] do
    collection do
      get :search
    end
  end

  # Admin Namespace for Emergency Respondents
  namespace :admin do
    resources :emergency_organizations, only: [] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :emergency_respondents, only: [] do
      member do
        patch :verify
      end
    end
  end

  # Emergency Respondents (Individual)
  resources :emergency_respondents, only: [:index, :new, :create, :edit, :update, :destroy] do
    get 'register/:token', to: 'emergency_respondents#new', as: :register, on: :collection
  end

  # Health Check & PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
