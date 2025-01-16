Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :staffs

  resources :organizations
  resources :patients, only: [:new, :create]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  unauthenticated do
    root to: "home#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
