require 'rails_helper'

RSpec.describe BrekkiesController, type: :controller do
  describe "brekkies#index action" do
    it "should successfully show the page" do 
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "brekkies#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "brekkies#create action" do
    it "should successfully create a new brekkie in our database" do
      post :create, params: { brek: { message: 'Hello' } }
      expect(response).to redirect_to root_path

      brek = Brek.last
      expect(brek.message).to eq('Hello')
    end

    it "should properly deal with vaildation errors" do
      post :create, params: { brek: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Brek.count).to eq 0
    end
  end
end
