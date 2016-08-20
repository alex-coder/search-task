Rails.application.routes.draw do
  root 'welcome#index'
  get 'search', controller: :welcome, action: :search, format: false
  resources :tags, format: false
  resources :activities, format: false
  resources :attractions, format: false
end
