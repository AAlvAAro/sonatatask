Rails.application.routes.draw do
	resources :users, except: ['index', 'new', 'edit'] do 
    member do
      get :search_tasks
    end
  end
  
  resources :tasks, except: ['new', 'edit'] do
    member do
      patch :check
      post :share
      post :attach_image
    end 

    resources :tags, only: ['create', 'update', 'destroy']
  end

  match '*path', to: 'application#not_found', via: :all
end
