Rails.application.routes.draw do
  resources :users, except: ['new', 'edit']

  resources :tasks, except: ['index', 'new', 'edit'] do
    member do
      patch :check
      post :share
    end 

    resources :tags, only: ['create', 'update', 'destroy']
  end
end
