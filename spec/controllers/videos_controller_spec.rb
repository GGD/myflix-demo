require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "assigns @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects the user to sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it "assigns @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'Monk')
      get :search, search_term: 'Mo'
      expect(assigns(:videos)).to eq([video])
    end

    it "redirects the user to sign in page for unauthenticated users" do
      video = Fabricate(:video, title: 'Monk')
      get :search, search_term: 'Mo'
      expect(response).to redirect_to sign_in_path
    end
  end
end