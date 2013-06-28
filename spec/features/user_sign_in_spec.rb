require 'spec_helper'

feature "User signs in" do
  scenario "with existing email and password" do
    tifa = Fabricate(:user)
    sign_in(tifa)
    expect(page).to have_content tifa.full_name
  end
end