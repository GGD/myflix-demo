require 'spec_helper'

feature "User invites friend" do
	scenario "User successfully invites friend and invitation is accepted" do
		tifa = Fabricate(:user)
		sign_in(tifa)
		
		invite_a_friend
		friend_accepts_invitation
		
		friend_should_follow(tifa)
		inviter_sould_follow_frient(tifa)

		clear_email
	end

	def invite_a_friend
		visit new_invitation_path
		fill_in "Friend's Name", with: "GI Joe"
		fill_in "Friend's Email Address", with: "gigoe@example.com"
		fill_in "Message", with: "Join with me!"
		click_button "Send Invitation"
		sign_out
	end

	def friend_accepts_invitation
		open_email "gigoe@example.com"
		current_email.click_link "Accept this invitation"
		fill_in "Password", with: '1234'
		fill_in "Full Name", with: "GI Joe"
		click_button "Sign Up"
	end

	def friend_should_follow(user)
		click_link "People"
		expect(page).to have_content user.full_name
		sign_out
	end

	def inviter_sould_follow_frient(user)
		sign_in(user)
		click_link "People"
		expect(page).to have_content "GI Joe"
	end
end