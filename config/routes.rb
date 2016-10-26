Rails.application.routes.draw do
  resources :columns
  resources :boards
  resources :projects
  resources :assignees
  resources :milestones
  resources :tasks
  resources :filters

  root to: 'welcome#index'

  mount ActionCable.server => '/cable'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  get 'users/:id', to: 'users#show', as: :user
  patch 'users/:id', to: 'users#update'
end
