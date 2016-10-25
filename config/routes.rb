Rails.application.routes.draw do
  resources :columns
  resources :boards
  resources :projects
  resources :assignees
  resources :milestones
  resources :tasks
  resources :filters
  resources :users

  root to: 'welcome#index'

  mount ActionCable.server => '/cable'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
end
