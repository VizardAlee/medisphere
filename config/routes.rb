Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :staffs

  resources :organizations
  resources :patients, only: [:new, :create, :index, :show, :edit, :update] do
    resources :health_records, only: %i[new create show edit update destroy]
  end

  resources :health_records, only: [:new, :create, :index, :show, :edit, :update, :destroy]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  # get 'staff/dashboard', to: 'staffs#dashboard', as: :staff_dashboard

  unauthenticated do
    root to: "home#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
