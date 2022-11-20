Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :v1, defaults: { format: :json} do
    resources :applications, param: :token, except: [:index, :destroy] do
      resources :chats, param: :number, only: [:show, :create] do
        resources :messages, param: :number, except: [:destroy]
      end
    end
  end
end
