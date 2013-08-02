require 'spec_helper'

feature "User registers", { js: true, vcr: true } do
  background { visit register_path }

  scenario "valid personal info and valid card" do
    fill_in "Email Address", with: "ggd@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full Name", with: "Ga Dii"
    pay_with_credit_card('4242424242424242')
    expect(page).to have_content "Ga Dii"
  end

  scenario "valid personal info and declined card" do
    fill_in "Email Address", with: "ggd@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full Name", with: "Ga Dii"
    pay_with_credit_card('4000000000000002')
    expect(page).to have_content "Your card was declined"
  end

  scenario "valid personal info and invalid card number" do
    fill_in "Email Address", with: "ggd@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full Name", with: "Ga Dii"
    pay_with_credit_card('1234')
    expect(page).to have_content "This card number looks invalid Credit Card Number"
  end

  scenario "invalid personal info and valid card" do
    fill_in "Email Address", with: "ggd@example.com"
    fill_in "Password", with: "1234"
    pay_with_credit_card('4242424242424242')
    expect(page).to have_content "Please check your input below"
  end
end

def pay_with_credit_card(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select "7 - July", from: 'date_month'
  select "2015", from: 'date_year'
  click_button "Sign Up"
end