Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/contact'

  resources :information do
    collection do
      get :all
      get 'draw/:gene', to: 'information#draw'
    end

  end
  resources :real_data_y, param: 'chart/:gene' do #
    collection do
      get 'search/:chart/:gene', to: 'real_data_y#search'
      get 'draw/:gene', to: 'real_data_y#draw', as: :draw
    end
  end

  # get 'information/all/(:uid)', to: 'information#all', as: 'all_information'
  # get 'information/draw/(:uid)/:gene', to: 'information#draw', as: 'draw'
  # get 'search/(:uid)/(:gene)/:chart', to: 'real_data_y#search', as: 'search_data'
  # get 'draw/(:uid)/:gene', to: 'real_data_y#draw', as: 'real_draw_y'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
