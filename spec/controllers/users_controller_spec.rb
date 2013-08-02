require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "POST create" do
    context "valid personal info and valid card" do
      let (:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "puts the user in session" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "redirects to categories_path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to categories_path
      end

      it "makes the user follow the inviter" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        post :create, user: { email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF' }, invitation_token: invitation.token
        cloud = User.where(email: 'cloud@example.com').first
        expect(cloud.follow?(tifa)).to be_true
      end

      it "makes the inviter follow the user" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        post :create, user: { email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF' }, invitation_token: invitation.token
        cloud = User.where(email: 'cloud@example.com').first
        expect(tifa.follow?(cloud)).to be_true
      end

      it "expires the invitation upon acceptance" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        post :create, user: { email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF' }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "email sending" do
      let (:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }
      
      it "sends out the email with valid inputs" do
        post :create, user: { email: 'tifa@example.com', password: '1234', full_name: 'Tifa FF' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['tifa@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'tifa@example.com', password: '1234', full_name: 'Tifa FF' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Tifa FF')
      end
    end

    context "valid personal info and declined card" do
      it "does not craete a new user record" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(flash[:error]).to be_present
      end
    end

    context "invalid personal info" do
      before do
        post :create, user: { password: '1234', full_name: 'Ga Dii' }
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "render :new template" do
        expect(response).to render_template :new
      end

      it "does not send out email with invalid inputs " do
        post :create, user: { email: 'tifa@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { password: '1234', full_name: 'Ga Dii' }
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