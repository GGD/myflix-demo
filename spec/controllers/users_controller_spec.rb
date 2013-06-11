require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "POST create" do
    it "assigns @user" do
      post :create, user: { email: nil, password: '1234', full_name: 'Ga Dii' }
      expect(assigns(:user)).to be_new_record
    end

    it "create user and redirect to categories_path when params is valid" do
      expect{ post :create, user: Fabricate.attributes_for(:user) }.to change(User, :count).by(1)
      expect(response).to redirect_to categories_path
    end

    it "render :new template when create user failed" do
      post :create, user: { email: nil, password: '1234', full_name: 'Ga Dii' }
      expect(User.count).to eq(0)

      expect(response).to render_template :new
    end
  end
end 