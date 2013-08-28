require 'spec_helper'

feature "User signs in" do
  scenario "with existing email and password" do
    tifa = Fabricate(:user)
    sign_in(tifa)
    expect(page).to have_content tifa.full_name
  end

  scenario "with deactivated user" do
    tifa = Fabricate(:user, active: false)
    sign_in(tifa)
    expect(page).not_to have_content(tifa.full_name)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end
