Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/contact'

  resources :information
  resources :real_data_y, param: 'patient/:gene/:chart'

  get 'information/all/(:patient)', to: 'information#all', as: 'all_information'
  get 'information/draw/(:patient)/(:gene)', to: 'information#draw', as: 'draw'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
