require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email can't be blank.")
      end
    end

    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: 'ggd@example.com')
        post :create, email: 'ggd@example.com'
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out an email to the email address" do
        Fabricate(:user, email: 'ggd@example.com')
        post :create, email: 'ggd@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['ggd@example.com'])
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: 'foo@example.com'
        expect(response).to redirect_to forgot_password_path
      end

      it "shows error message" do
        post :create, email: 'foo@example.com'
        expect(flash[:error]).to eq("No email matched.")
      end
    end
  end
end