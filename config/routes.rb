Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/contact'

  resources :information
  resources :real_data_y, param: 'uid/:gene/:chart'

  get 'information/all/(:uid)', to: 'information#all', as: 'all_information'
  get 'information/draw/(:uid)/(:gene)', to: 'information#draw', as: 'draw'
  get 'search/(:uid)/(:gene)/:chart', to: 'real_data_y#search', as: 'search_data'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
