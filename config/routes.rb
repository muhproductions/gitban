Rails.application.routes.draw do
  resources :columns
  resources :boards
  resources :projects
  resources :assignees
  resources :milestones
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
