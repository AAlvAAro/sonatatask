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
      get :filter_by_tag
      post :add_tags
      delete :remove_tag
    end 
  end

  match '*path', to: 'application#not_found', via: :all
end
