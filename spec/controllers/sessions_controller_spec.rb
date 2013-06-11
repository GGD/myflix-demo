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
    context "with valid credentials" do
      before do
        @ted = Fabricate(:user)
        post :create, email: @ted.email, password: @ted.password
      end

      it "puts signed in user in session" do
        expect(session[:user_id]).to eq(@ted.id)
      end

      it "redirects to categories_path" do
        expect(response).to redirect_to categories_path
      end
    end

    context "with invalid credentials" do
      before do
        @ted = Fabricate(:user)
        post :create, email: @ted.email, password: @ted.password + 'asdfasdf'
      end

      it "does not pusts signed in user in session" do
        expect(session[:user_id]).to be_nil
      end

      it "renders :new template with error message" do
        expect(flash[:error]).not_to be_blank
        expect(response).to render_template :new
      end
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