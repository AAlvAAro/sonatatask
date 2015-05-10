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
    @task = Task.create(params)
    if @task.persisted?
      empty_ok_response
    else
      respond_with_errors(@task.errors)
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(params)
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
    @task = Task.find(params[:id]
    @task.sharer_id = current_user.id
    @task.sharer_username = current_user.username
    @friend = User.find(params[:id])
    @friend.shares << @task
    if @friend.shares.save!
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
end
