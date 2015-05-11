class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks
    render json: { tasks: @tasks }, status: :ok
  end

  def show
    @task = Task.find(params[:id])
    render json: @task, status: 200
  end

  def create
    @task = Task.create(task_params)
    if @task.persisted?
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    if @task.save!
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end   
  end

  def share
    @friend = User.find(params[:friend_id])
    @friend.shares.create(
      expiration: params[:expiration],
      content: params[:content],
      sharer_id: params[:id],
      sharer_username: params[:username]
    )
    if @friend.persisted?
      empty_ok_response
    else
      respond_with_errors(@friend.errors)
    end
  end

  def attach_image
    @task = Task.find(params[:id])
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

  private
    def task_params
      params.permit(:expiration, :content)
    end
end
