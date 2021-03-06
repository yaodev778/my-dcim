Rails.application.routes.draw do

  get 'data_import', action: 'index', controller: 'data_import'
  post 'data_import/ansible'

  resources :sites
  resources :islets
  resources :disk_types
  resources :memory_types
  resources :memory_components
  resources :disks
  resources :maintainers
  resources :contract_types
  resources :maintenance_contracts
  resources :server_states

  resources :frames do
    collection do
      post :sort
    end
  end

  resources :ports, only: [:index, :edit, :update, :destroy]
  get 'connections/edit', :action => 'edit', controller: 'connections'
  post 'connections/update_destination_server', :action => 'update_destination_server', controller: 'connections'
  post 'connections/update', :action => 'update', controller: 'connections'
  resources :cables, only: [:destroy]

  resources :clusters
  resources :servers do
    collection do
      get :grid
      post :sort
      get :import_csv
      post :import
    end
  end
  resources :servers_grids, only: [:index] do
    collection do
      get :reseau
    end
  end
  resources :card_types
  resources :colors
  resources :rooms do
    collection do
      get :islet
      get :overview
    end
  end
  resources :bays
  resources :gestions
  resources :domaines
  resources :modeles
  resources :marques
  resources :architectures
  resources :categories
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end
    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end
  root to: 'pages#index'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", :registrations => "users/registrations" }
  resources :users

  resources :activities
end
