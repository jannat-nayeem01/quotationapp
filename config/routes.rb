Rails.application.routes.draw do
  resources :quotations do
    collection do
      get 'export_xml', to: 'quotations#export_xml', defaults: { format: 'xml' }
      get 'export_json', to: 'quotations#export_json', defaults: { format: 'json' }
      post 'import_xml', to: 'quotations#import_xml'
      post 'import_xml_external', to: 'quotations#import_xml_external'
end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'search_quotations', to: 'quotations#search'

  # Defines the root path route ("/")
 root "quotations#index"
end
