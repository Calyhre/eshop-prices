Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get :prices, to: 'application#prices'
  get :rates, to: 'application#rates'
end
