require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "POST create" do
    context "successful user sign up" do
      before do
        result = double(:sign_up_result, successful?: true, session: 1)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
      end

      it "puts the user in session" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(1 )
      end

      it "redirects to categories_path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to categories_path
      end
    end

    context "failed user sign up" do
      before do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
      end

      it "renders the new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let (:action) { get :show, id: 1 }
    end

    it "assigns @user" do
      set_current_user
      tifa = Fabricate(:user)
      get :show, id: tifa.id
      expect(assigns(:user)).to eq(tifa)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'some token'
      expect(response).to redirect_to expired_token_path
    end
  end
end