Rails.application.routes.draw do
  root 'status#index'
  get 'auth/google_oauth2/callback', to: 'session#create'
  get 'auth', to: redirect(Google::OAuth.auth_uri)
  get 'settings', to: 'settings#index'
  put 'settings', to: 'settings#update'

  namespace :api do
    post  "/webhooks/temp", to: "webhooks#temp"
  end
end
