Rails.application.routes.draw do
  resources :users

  resources :tasks do
    member do
      patch :check
      post :share
    end 
  end
end
