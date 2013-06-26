require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "assigns @video for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "assigns @reviews for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array [review1, review2]
    end

    it_behaves_like "require_sign_in" do
      let (:action) { get :show, id: 1 }
    end
  end

  describe "GET search" do
    it "assigns @videos for authenticated users" do
      set_current_user
      video = Fabricate(:video, title: 'Monk')
      get :search, search_term: 'Mo'
      expect(assigns(:videos)).to eq([video])
    end

    it_behaves_like "require_sign_in" do
      let (:action) { get :search, search_term: 'something' }
    end
  end
end