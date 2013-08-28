require 'spec_helper'

describe "Deactive user on failed charge" do
  let (:event_data) do
    {
      "id" => "evt_2T5VO7EueJwESr",
      "created" => 1377697795,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_2T5VuvQZCh1Gn3",
          "object" => "charge",
          "created" => 1377697795,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_2T5U2BZmD6tfSE",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 8,
            "exp_year" => 2016,
            "fingerprint" => "i5dzm1irLnbtYgJF",
            "customer" => "cus_2SK5s9xmRc4UzR",
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
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_2SK5s9xmRc4UzR",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "fee" => 0,
          "fee_details" => []
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2T5VYkPglpZos9"
    }
  end

  it "deactives a user with the web hook data from stripe for charge failed", :vcr do
    tifa = Fabricate(:user, stripe_customer_token: "cus_2SK5s9xmRc4UzR")
    post "/stripe_events", event_data
    expect(tifa.reload).not_to be_active
  end
end
