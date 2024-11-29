require "sidekiq/web"

Sidekiq::Web.use(Rack::Auth::Basic, "Sidekiq Dashboard") do |username, password|
  username == Rails.application.credentials.dig(:sidekiq, :username) &&
    password == Rails.application.credentials.dig(:sidekiq, :password)
end

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources "invites", only: [:new, :create]
  resources "tasks", only: [:create, :edit, :update, :destroy] do
    get "delete_confirmation", on: :member
  end
  resources "boards" do
    get "delete_confirmation", on: :member
  end
  resource "session", only: [:show, :new, :create, :destroy]
  resources "users", only: [:new, :create, :destroy]
  resources "passwords", param: :token
  root "home#index"

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  get "up", to: "rails/health#show", as: :rails_health_check
end
