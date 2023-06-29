Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # You can have the root of your site routed with "root"

  ###
  root to: "admin/dougus#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :members do
    collection { post :import }
  end 

  resource :member_imports
  resources :dougu_type do
    collection { post :import }
  end

  resource :dougu_type_imports
  resources :dougu_sub_type do
    collection { post :import }
  end

  resource :dougu_sub_type_imports

  resource :dougu_imports
  resources :dougu do
    collection { post :import }
  end

  resource :dougu_imports


  resource :labels
  resource :books
end
