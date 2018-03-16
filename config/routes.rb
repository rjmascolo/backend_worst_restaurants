Rails.application.routes.draw do
  resources :inspections
  get '/worst-restaurants', to: 'inspections#get_worst_restaurant_scores'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
