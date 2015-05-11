class UsersController < ApplicationController
  before_action :authenticate_request, except: ['create']

  def show
    @user = User.find(params[:id])
    render json: { user: @user }, status: :ok
  end

  def create
    @user = User.create(user_params)
    if @user.persisted?
      render json: { auth_token: @user.auth_token }, status: :ok
    else
      respond_with_errors(@user.erors)
    end
  end

  def update
    @user.update_attributes(user_params)
    if @user.save!
      render json: { auth_token: @user.auth_token }, status: :ok
    else
      respond_with_errors(@user.errors)
    end
  end

  def destroy
    if @user.find(params[:id]).destroy
      empty_ok_response
    else
      respond_with_errors(@user.errors)
    end
  end

  def search_tasks
    @tasks = current_user.tasks.es.search(params[:query]).results
    render json: { tasks: @tasks }, status: :ok
  end

  private
    def user_params
      params.permit(:username, :password)
    end

end
