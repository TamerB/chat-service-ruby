Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :search_paginatable do
    get '(page/:page)', action: :search, on: :collection, as: ''
  end

  namespace :v1, defaults: { format: :json} do
    resources :applications, param: :token, except: [:index, :destroy] do
      resources :chats, param: :number, only: [:index, :show, :create], concerns: :paginatable do
        resources :messages, param: :number, except: [:destroy], concerns: :paginatable do
          get 'search/:phrase/(page/:page)', action: :search, on: :collection
        end
      end
    end
  end

  get 'healthz', to: 'health#health'
  get 'readyz', to: 'health#health'

  match '*path', to: "errors#handle_root_not_found", via: [:get, :post]
end
