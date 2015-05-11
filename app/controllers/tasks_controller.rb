class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks
    render json: { tasks: @tasks }, status: :ok
  end

  def show
    @task = Task.find(params[:id])
    render json: { task: @task }, status: 200
  end

  def create
    @task = Task.create(
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
    @task = Task.find(params[:id])
    @task.update_attributes(params.permit(:finished, :expiration, :content))
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

  def check
    @task = Task.find(params[:id])
    @task.finished = true
    if @task.save!
      render json: { checked: true }, status: :ok
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

  def filter_by_tag
    @tasks = current_user.tasks.where
  end

  def add_tags
    # Add comma separated tags to the tag array
    @task = Task.find(params[:id])
    @task.tags.concat(params[:tags])
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
end
