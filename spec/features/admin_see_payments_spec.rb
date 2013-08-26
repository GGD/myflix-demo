require 'spec_helper'

feature "Admin sees payments" do
  background do
    tifa = Fabricate(:user, full_name: "Tifa FF", email: "tifa@example.com")
    Fabricate(:payment, amount: 999, user: tifa)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path

    expect(page).to have_content("$9.99")
    expect(page).to have_content("Tifa FF")
    expect(page).to have_content("tifa@example.com")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path

    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Tifa FF")
    expect(page).to have_content("You are not authorized to do that.")
  end
end
