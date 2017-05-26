Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get :best_deals, to: 'application#best_deals'
  get :rates, to: 'application#rates'
  get :glossary, to: 'application#glossary'
  get :about, to: 'application#about'

  resources :games, only: :index
  resources :prices, only: :index
end
