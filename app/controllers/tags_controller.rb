class TagsController < ApplicationController
  before_action :authenticate_user

  def create
  	@task = Task.find(params[:id])
  	@task.tags.create(name: params[:name])
  	if @task.persisted?
  		empty_ok_response
  	else
  		respond_with_errors(@task.errors)
  	end
  end

  def update
  	@tag = Tag.find(params[:id])
  	@tag.name = params[:name]
 	if @tag.save!
  		empty_ok_response
  	else
  		respond_with_errors(@tag.errors)
  end

  def destroy
  	@tag = Tag.find(params[:id])
  	if @tag.destroy
  		empty_ok_response
  	else
  		respond_with_errors(@tag.errors)
  	end
  end
end
