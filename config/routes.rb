Rails.application.routes.draw do
  
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { post :import }
    
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      
      get '/on_duty', to: 'users#on_duty'
      get '/basic', to: 'users#basic'
    end
    resources :attendances, only: :update do
    end
    resources :offices
    resources :approvals do 
      member do
        get 'edit_month_application'
        patch 'update_month_application'
      end
    end
    resources :overtimes
  end
end
