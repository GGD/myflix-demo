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

    it "assigns @queue_items order by position" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      queue_item1 = Fabricate(:queue_item, user: tifa, position: 2)
      queue_item2 = Fabricate(:queue_item, user: tifa, position: 3)
      queue_item3 = Fabricate(:queue_item, user: tifa, position: 1)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item3, queue_item1, queue_item2])
    end

    it "redirects to sign in page for unauthenticated user" do
      session[:user_id] = nil
      get :index 
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirects to my queue page" do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: Fabricate(:video).id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item associated with the sign in user" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(tifa)
    end

    it "puts the video as the last one in the queue" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: tifa)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: tifa.id).first
      expect(video2_queue_item.position).to eq(2)
    end

    it "adds the video only once in the queue" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: tifa )
      post :create, video_id: video.id
      expect(tifa.queue_items.count).to eq(1)
    end

    it "redirects to sign in page for unauthenticated users" do
      post :create, video_id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    it "redirects to my queue page" do
      session[:user_id] = Fabricate(:user).id
      delete :destroy, id: Fabricate(:queue_item)
      expect(response).to redirect_to my_queue_path
    end

    it "delete the queue item" do
      tifa = Fabricate(:user)
      session[:user_id] = tifa.id
      queue_item = Fabricate(:queue_item, user: tifa)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not delete the queue item if the current user is not the owner" do
      tifa = Fabricate(:user)
      yuri = Fabricate(:user)
      session[:user_id] = tifa.id
      queue_item = Fabricate(:queue_item, user: yuri)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to sign in page for unauthenticated users " do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST order_exchanging" do
    context "with valid inputs" do
      it "redirects to my_queue_path" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        post :order_exchanging, position: { "1" => queue_item1.position.to_s, "2" => queue_item2.position.to_s }
        expect(response).to redirect_to my_queue_path
      end

      it "returns to first position when order is the smallest one" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: tifa, position: 3)
        post :order_exchanging, position: { "1" => "11", "2" => "8", "3" => "7" }
        expect(QueueItem.last.position).to eq(1)
      end
      it "returns to last position when order is the biggest one" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: tifa, position: 3)
        post :order_exchanging, position: { "1" => "11", "2" => "8", "3" => "7" }
        expect(QueueItem.first.position).to eq(3)
      end
    end

    context "with invalid inputs" do
      it "does not change positions for non integer order" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: tifa, position: 3)
        post :order_exchanging, position: { "1" => "11", "2" => "8", "3" => "a" }
        expect(QueueItem.last.position).to eq(3)
      end

      it "redirects to my_queue_path" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: tifa, position: 3)
        post :order_exchanging, position: { "1" => "11", "2" => "8", "3" => "a" }
        expect(response).to redirect_to my_queue_path
      end

      it "shows error message" do
        tifa = Fabricate(:user)
        session[:user_id] = tifa.id
        queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: tifa, position: 3)
        post :order_exchanging, position: { "1" => 11, "2" => 8, "3" => "a" }
        expect(flash[:error]).not_to be_empty
      end
    end
  end
end