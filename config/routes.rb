Rails.application.routes.draw do
  resources :columns
  resources :boards
  resources :projects
  resources :assignees
  resources :milestones
  resources :tasks
  
  root to: 'welcome#index'

  get 'settings', to: 'settings#index' 
  put 'settings', to: 'settings#update'

  mount ActionCable.server => '/cable'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
end
