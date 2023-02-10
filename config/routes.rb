Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :items do
        resources :find, only: [:index]
      end
      namespace :merchants do
        resources :find_all, only: [:index]
      end
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], controller: 'merchant_items'
      end
      resources :items, except: [:new, :edit] do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end
    end
  end
end
