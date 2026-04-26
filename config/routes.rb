Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :blog_posts, path: "blog", only: %i[index show]
  resources :contact_inquiries, path: "contact", only: %i[new create]

  namespace :admin, path: "dashboard" do
    get "/", to: "dashboard#index", as: :dashboard
    resources :patients
    resources :doctors
    resources :tests
    resources :bills do
      member do
        get :print
        get :pdf
      end
    end
    resources :reports
    get "referral_reports", to: "referral_reports#index", as: :referral_reports
    get "referral_reports/export", to: "referral_reports#export", as: :referral_reports_export
    resources :blog_posts, except: :show
    resources :contact_inquiries, only: %i[index show destroy]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
