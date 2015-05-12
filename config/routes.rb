Rails.application.routes.draw do
	resources :users, except: ['index', 'new', 'edit'] do 
    member do
      get :search_tasks
      get :shares
    end

    resources :tasks, except: ['new', 'edit'] do
      member do
        patch :check
        post :attach_image
        get :filter_by_tag
        patch :add_tags
        delete :remove_tag
      end
      post '/share/:friend_id', to: 'tasks#share' 
    end
  end

  put '/update_share/:share_id', to: 'tasks#update_share'
  delete '/destroy_share/:share_id', to: 'tasks#destroy_share'
  

  match '*path', to: 'application#not_found', via: :all
end
