require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders :new template for unauthenticated user" do
      expect(get :new).to render_template :new
    end

    it "redirects to home_path for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      expect(get :new).to redirect_to home_path
    end
  end

  describe "POST create" do
    it "puts authenticated user in session and redirects to categories_path" do
      user = Fabricate(:user)
      post :create, email: user.email, password: user.password
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to categories_path
    end
    it "renders :new template for unauthenticated user" do
      user = Fabricate(:user)
      expect(post :create, email: user.email, password: nil).to render_template :new
    end
  end

  describe "GET destroy" do
    it "destroy session and redirects to root_path" do
      get :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to root_path
    end
  end
end