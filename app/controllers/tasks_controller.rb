class TasksController < ApplicationController
  before_action authenticate_user unless Rails.env.test?

  def index
    get_pagination_terms
    @tasks = User.find(params[:user_id]).tasks.paginate(page: page, per_page: offset)
    render json: { tasks: @tasks }, status: :ok
  end

  def show
    @task = User.find(params[:user_id]).tasks.find(params[:id])
    render json: { task: @task }, status: 200
  end

  def create
    @task = User.find(params[:user_id]).tasks.create(
      expiration: params[:expiration],
      content: params[:content],
      tags: params[:tags].to_a
    )
    if @task.persisted?
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def update
    @task = User.find(params[:user_id]).tasks.find(params[:id])
    @task.update_attributes(params.permit(:finished, :expiration, :content))
    if @task.save!
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def destroy
    @task = User.find(params[:user_id]).tasks.find(params[:id])
    if @task.destroy
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end   
  end

  def check
    @task = User.find(params[:user_id]).tasks.find(params[:id])
    @task.finished = true
    if @task.save!
      render json: { checked: true }, status: :ok
    else
      respond_with_errors(@task.errors)
    end
  end

  # Create, Update and Destroy shares on both sides
  def share
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    task = @user.find(params[:task_id])
    share_obj = {
      finished: task.finished,
      expiration: task.expiration,
      content: task.content,
      tags: task.tags,
      share_id: task.id.to_s,
      owner_id: user.id,
      friend_id: friend.id  
    }
    @user.tasks.create(share_obj)
    @friend.tasks.create(share_obj)
    if @user.persisted? && @friend.persisted?
      empty_ok_response
    else
      render json: { error: "Share couldn't be saved" }, status: :unprocessable_entity
    end
  end

  def get_shares
    @shares = User.find(params[:id]).shares
    render json: { shares: @shares }, status: :ok
  end

  def update_share
    @user_share = User.find(params[:user_id]).shares.find(params[:share_id])
    @friend_share = User.find(params[:friend_id]).shares.find(params[:share_id])
    @user_share.update_attributes(share_params)
    @friend_share.update_attributes(share_params)
    if @user_share.persisted? && @friend_share.persisted?
      empty_ok_response
    else
      render json: { error: "Share couldn't be updated" }, status: :unprocessable_entity
    end
  end

  def destroy_share
    @user_share = User.find(params[:user_id]).find(params[:share_id]).destroy
    @friend_share = User.find(params[:friend_id]).find(params[:share_id]).destroy
    if @user_share.destroyed? and @friend_share.destroyed?
      empty_ok_response
    else
      render json: { error: "Share couldn't be deleted" }, status: :unprocessable_entity
    end
  end

  def attach_image
    @task = User.find(params[:user_id]).tasks.find(params[:id])
    @image = @task.images.new
    tmp = params[:file].tempfile
    img = MiniMagick::Image.read(tmp)
    @image.image = File.open(img.path) 
    if @image.save!
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def search_tasks
    get_pagination_terms
    @tasks = current_user.tasks.es.search(params[:query], page: page, per_page: offset).results
    render json: { tasks: @tasks }, status: :ok
  end

  def filter_by_tag
    get_pagination_terms
    @tasks = User.find(params[:user_id]).tasks.all_in(tags: params[:tag])
    render json: { tasks: @tasks }
  end

  def add_tags
    # Add comma separated tags to the tags array
    @task = Task.find(params[:id])
    @task.tags.concat(params[:tags].delete(" ").split(","))
    if @task.save!
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def remove_tag
    @task = Task.find(params[:id])
    @task.delete(params[:tag])
    if @task.save!
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  private
    def get_pagination_terms
      # set pagination terms by getting the params in the form ?page=page_number&offset=offset_number 
      # or use the defaults
      page = params[:page] || 1
      offset = params[:offset] || 10
    end

    def share_params
      params.permit(:finished, :expiration, :content, :tags)
    end
end
