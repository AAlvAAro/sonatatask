Rails.application.routes.draw do
	resources :users, except: ['index', 'new', 'edit']
  
  resources :tasks, except: ['new', 'edit'] do
    member do
      patch :check
      post :share
    end 

    resources :tags, only: ['create', 'update', 'destroy']
  end

  match '*path', to: 'application#not_found', via: :all
end
