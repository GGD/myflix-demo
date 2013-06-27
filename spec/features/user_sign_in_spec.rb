require 'spec_helper'

feature "User signs in" do
  scenario "with existing email and password" do
    tifa = Fabricate(:user)
    visit sign_in_path
    fill_in 'Email Address', with: tifa.email
    fill_in 'Password', with: tifa.password
    click_button 'Sign in'
    expect(page).to have_content tifa.full_name
  end
end