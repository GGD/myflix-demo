require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      tifa = Fabricate(:user, token: '12345')
      get :show, id: tifa.token
      expect(response).to render_template :show
    end

    it "assings @token" do
      tifa = Fabricate(:user, token: '12345')
      get :show, id: tifa.token
      expect(assigns(:token)).to eq(tifa.token)
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to sign in page" do
        tifa = Fabricate(:user, token: '12345', password: 'old_password')
        post :create, token: tifa.token, password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end

      it "udpates the user's password" do
        tifa = Fabricate(:user, token: '12345', password: 'old_password')
        post :create, token: tifa.token, password: 'new_password'
        expect(tifa.reload.authenticate('new_password')).to be_true
      end

      it "assings flash success message" do
        tifa = Fabricate(:user, token: '12345', password: 'old_password')
        post :create, token: tifa.token, password: 'new_password'
        expect(flash[:success]).to be_present
      end

      it "regenerates the uesr token" do
        tifa = Fabricate(:user, password: 'old_password')
        tifa.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(tifa.reload.token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end