Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "dashboard" => "dashboard#index", as: :dashboard

  resources :broker_applications, only: %i[new create show] do
    resource :hp_agreement, only: %i[new create show], controller: :broker_hp_agreements
    resource :purchase_invoice, only: %i[new create show], controller: :broker_purchase_invoices
  end
end
