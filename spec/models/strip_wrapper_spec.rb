require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Subscribe do
    describe ".create" do
      it "makes a successful subscribe", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4242424242424242",
            exp_month: 7,
            exp_year: 2018,
            cvc: "314"
          },
        ).id

        response = StripeWrapper::Subscribe.create(
          email: 'tifa@example.com',
          card: token,
          description: "a valid subscribe"
        )

        expect(response).to be_successful
      end

      it "makes a card declined subscribe", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4000000000000002",
            exp_month: 7,
            exp_year: 2018,
            cvc: "314"
          },
        ).id

        response = StripeWrapper::Subscribe.create(
          email: 'tifa@example.com',
          card: token,
          description: "an invalid subscribe"
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined subscribe", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4000000000000002",
            exp_month: 7,
            exp_year: 2018,
            cvc: "314"
          },
        ).id

        response = StripeWrapper::Subscribe.create(
          email: 'tifa@example.com',
          card: token,
          description: "an invalid subscribe"
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end