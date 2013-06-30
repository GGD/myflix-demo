require 'spec_helper'

feature "User following" do
  scenario "user follows and unfollows someone" do
    tifa = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: tifa, video: video)

    sign_in

    click_on_video_on_home_page(video)

    click_link tifa.full_name
    click_link 'Follow'
    expect(page).to have_content tifa.full_name

    unfollow(tifa)
    expect(page).not_to have_content tifa.full_name
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end