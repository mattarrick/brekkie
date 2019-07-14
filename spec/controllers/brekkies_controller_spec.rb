require 'rails_helper'

RSpec.describe BrekkiesController, type: :controller do
  describe "brekkies#show action" do
    it "should successfully show the page if the brekkie is found" do
      brek = FactoryBot.create(:brek)
      get :show, params: { id: brek.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the brekkie is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "brekkies#index action" do
    it "should successfully show the page" do 
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "brekkies#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "brekkies#create action" do
    it "should require users to be logged in" do
      post :create, params: { brek: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new brekkie in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { brek: { message: 'Hello' } }
      expect(response).to redirect_to root_path

      brek = Brek.last
      expect(brek.message).to eq('Hello')
      expect(brek.user).to eq(user)
    end

    it "should properly deal with vaildation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      brek_count = Brek.count
      post :create, params: { brek: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(brek_count).to eq Brek.count
    end
  end
end
