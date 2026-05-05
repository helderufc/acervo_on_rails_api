Rails.application.routes.draw do
  devise_for :users,
    path: "auth",
    path_names: { sign_in: "login", sign_out: "logout", registration: "signup" },
    controllers: {
      sessions: "auth/sessions",
      registrations: "auth/registrations"
    }

  resources :users, only: [ :show, :update, :destroy ] do
    member do
      patch :encerrar
    end
  end

  resources :conteudos, only: [ :index, :show, :create, :update, :destroy ] do
    resources :marcadores, only: [ :index, :create ], module: :conteudos
    member do
      delete "marcadores/:marcador_id", to: "conteudos/marcadores#destroy", as: :marcador
    end
  end

  resources :marcadores, only: [ :index, :show, :create, :update, :destroy ] do
    resources :conteudos, only: [ :index ], module: :marcadores
  end

  resources :denuncias, only: [ :create ]

  namespace :admin do
    resources :conteudos, only: [ :destroy ]
    resources :marcadores, only: [ :destroy ]
    resources :users, only: [] do
      member do
        patch :desativar
        patch :reativar
        patch :promover
        patch :revogar
      end
    end
    resources :denuncias, only: [ :index, :show ] do
      member do
        patch :resolver
        patch :ignorar
      end
    end
    resources :motivos
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
