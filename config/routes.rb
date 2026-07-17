Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  devise_scope :user do
    resource :registration,
             only: %i[edit update destroy],
             path: "users",
             path_names: { edit: "edit" },
             controller: "devise/registrations",
             as: :user_registration
  end

  root "home#index"
  resources :blog_posts, path: "blog", only: %i[index show]
  resources :contact_inquiries, path: "contact", only: %i[new create]
  resource :lab_registration, only: %i[new create]

  namespace :admin, path: "dashboard" do
    get "/", to: "dashboard#index", as: :dashboard
    resources :patients
    resources :doctors
    resources :tests
    resources :test_packages
    resources :bills do
      member do
        get :print
        get :pdf
      end
    end
    resources :reports
    get "referral_reports", to: "referral_reports#index", as: :referral_reports
    get "referral_reports/export", to: "referral_reports#export", as: :referral_reports_export
    resources :staff, only: %i[index create destroy]
    delete "staff_invitations/:id", to: "staff#destroy_invitation", as: :cancel_staff_invitation
  end

  get "staff_invitations/:token", to: "staff_invitations#show", as: :staff_invitation
  post "staff_invitations/:token", to: "staff_invitations#create"

  namespace :platform do
    root to: "dashboard#index"
    resources :labs, only: %i[index show update]
    resources :blog_posts, except: :show
    resources :contact_inquiries, only: %i[index show destroy]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
