require 'rails_helper'

RSpec.describe BrekkiesController, type: :controller do
  describe "brekkies#destroy action" do
    it "shouldn't allow users who didn't create the brekkie to destroy it" do
      brek = FactoryBot.create(:brek)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: brek.id }
      expect(response).to have_http_status(:forbidden)
    end
    
    it "shouldn't let unauthenticated users destroy a brekkie" do
      brek = FactoryBot.create(:brek)
      delete :destroy, params: { id: brek.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy a brekkie" do
      brek = FactoryBot.create(:brek)
      sign_in brek.user
      delete :destroy, params: { id: brek.id }
      expect(response).to redirect_to root_path
      brek = Brek.find_by_id(brek.id)
      expect(brek).to eq nil
    end

    it "should return a 404 message if we cannot find a brekkie with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "brekkies#update action" do
    it "shouldn't let users who didn't create the brekkie update it" do
      brek = FactoryBot.create(:brek)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: brek.id, brek: { message: 'wahoo' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a brekkie" do
      brek = FactoryBot.create(:brek)
      patch :update,  params: { id: brek.id, brek: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update brekkies" do
      brek = FactoryBot.create(:brek, message: "Initial Value")
      sign_in brek.user

      patch :update, params: { id: brek.id, brek: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      brek.reload
      expect(brek.message).to eq "Changed"
    end

    it "should have http 404 error if the brekkie cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user

      patch :update, params: { id: "YOLOSWAG", brek: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      brek = FactoryBot.create(:brek, message: "Initial Value")
      sign_in brek.user

      patch :update, params: { id: brek.id, brek: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      brek.reload
      expect(brek.message).to eq "Initial Value"
    end
  end

  describe "brekkies#edit action" do
    it "shouldn't let a user who did not create the brekkie edit the brekkie" do
      brek = FactoryBot.create(:brek)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: brek.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a brekkie" do
      brek = FactoryBot.create(:brek)
      get :edit, params: { id: brek.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the brekkie is found" do
      brek = FactoryBot.create(:brek)
      sign_in brek.user

      get :edit, params: { id: brek.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the brekkie is not found" do
      user = FactoryBot.create(:user)
      sign_in user

      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end

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
