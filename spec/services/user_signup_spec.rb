require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let (:subscribe) { double(:subscribe, successful?: true, id: 'some_token') }
      before { StripeWrapper::Subscribe.should_receive(:create).and_return(subscribe) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF')).sign_up("some_stripe_token", invitation.token)
        cloud = User.where(email: 'cloud@example.com').first
        expect(cloud.follow?(tifa)).to be_true
      end

      it "makes the inviter follow the user" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF')).sign_up("some_stripe_token", invitation.token)
        cloud = User.where(email: 'cloud@example.com').first
        expect(cloud.follow?(tifa)).to be_true
      end

      it "expires the invitation upon acceptance" do
        tifa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: tifa, recipient_email: 'cloud@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'cloud@example.com', password: '1234', full_name: 'Cloud FF')).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      it "sends out the email with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'tifa@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['tifa@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'tifa@example.com', full_name: 'Tifa FF')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Tifa FF')
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        subscribe = double(:subscribe, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Subscribe.should_receive(:create).and_return(subscribe)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "invalid personal info" do
      before do
        UserSignup.new(User.new(email: 'ggd@example.com')).sign_up("some_stripe_token", nil)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "does not send out email with invalid inputs " do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not subscribe" do
        StripeWrapper::Subscribe.should_not_receive(:create)
      end
    end
  end
end