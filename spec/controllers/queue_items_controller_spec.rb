require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    it "assigns @queue_items for authenticated user" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      queue_item1 = Fabricate(:queue_item, user: tifa)
      queue_item2 = Fabricate(:queue_item, user: tifa)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to sign in page for unauthenticated user" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end