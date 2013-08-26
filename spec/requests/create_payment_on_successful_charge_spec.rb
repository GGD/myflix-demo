require 'spec_helper'

describe "Create payment on successful charge" do
  let (:event_data) do
    {
      "id" => "evt_2RrwuZy3Kn0Mou",
      "created" => 1377416660,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_2RrvNfL3mCgzEN",
          "object" => "charge",
          "created" => 1377416659,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_2Rrvf3fFLALvgn",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 8,
            "exp_year" => 2015,
            "fingerprint" => "MDPDqQ5D8jnzbtjS",
            "customer" => "cus_2RrvJ2GLt9gcOI",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => true,
          "balance_transaction" => "txn_2RrwYJMe4FFBXk",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_2RrvJ2GLt9gcOI",
          "invoice" => "in_2RrvchYABpSCpE",
          "description" => nil,
          "dispute" => nil,
          "fee" => 59,
          "fee_details" => [
            {
              "amount" => 59,
              "currency" => "usd",
              "type" => "stripe_fee",
              "description" => "Stripe processing fees",
              "application" => nil
            }
          ]
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2RrvekIgldL64F"
    }
  end

  it "creates a payment with the webhhok from stripe for charge succeseded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr  do
    tifa = Fabricate(:user, stripe_customer_token: event_data["data"]["object"]["customer"])
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(tifa)
  end

  it "creates the payment with the amount", :vcr do
    tifa = Fabricate(:user, stripe_customer_token: event_data["data"]["object"]["customer"])
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    tifa = Fabricate(:user, stripe_customer_token: event_data["data"]["object"]["customer"])
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq('ch_2RrvNfL3mCgzEN')
  end
end
