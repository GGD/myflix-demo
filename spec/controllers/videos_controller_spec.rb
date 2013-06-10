require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Video.create(title: 'Monk', description: 'Moooonk', category_id: '1') }

    it "assigns @video for authenticated users" do
      User.create(email: 'ggd@example.com', password: '1234', full_name: 'Ga Dii')
      session[:user_id] = 1

      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "redirects the user to sign in page for unauthenticated users" do
      get :show, id: video
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    let(:videos) do
      2.times { Video.create(title: 'Monk', description: 'Moooonk', category_id: '1') }
    end

    it "assigns @videos for authenticated users" do
      User.create(email: 'ggd@example.com', password: '1234', full_name: 'Ga Dii')
      session[:user_id] = 1

      get :search, search_term: 'Monk'
      expect(assigns(:videos)).to eq(Video.all)
    end
    
    it "redirects the user to sign in page for unauthenticated users" do
      get :search, search_term: 'Monk'
      expect(response).to redirect_to sign_in_path
    end
  end
end