Rails.application.routes.draw do
  root 'welcome#index'
  get 'city/:id', controller: :application, action: :change_city, format: false, as: :city
  get 'search', controller: :welcome, action: :search, format: false
  resources :tags, format: false
  resources :activities, format: false
  resources :attractions, format: false
end
