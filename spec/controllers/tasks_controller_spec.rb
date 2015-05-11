require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  HOST = "http://localhost:3000"
  
  before :each do
    @user = FactoryGirl.create(:user_friend)
  end

  describe "GET tasks" do

    request_url = HOST + '/users/' + @user.username + '/tasks'

    it "returns http success" do
      get request_url
      expect_json_types({tasks: @user.tasks})
    end
  end

  # describe "GET #create" do
  #   it "returns http success" do
  #     get :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #update" do
  #   it "returns http success" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #delete" do
  #   it "returns http success" do
  #     get :delete
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
