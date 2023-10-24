Rails.application.routes.draw do
  resources :quotations

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'search_quotations', to: 'quotations#search'

  # Defines the root path route ("/")
 root "quotations#index"
end
