require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    before { set_current_user }

    it "assigns @queue_items for authenticated user" do
      tifa = current_user
      queue_item1 = Fabricate(:queue_item, user: tifa)
      queue_item2 = Fabricate(:queue_item, user: tifa)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "assigns @queue_items order by position" do
      tifa = current_user
      queue_item1 = Fabricate(:queue_item, user: tifa, position: 2)
      queue_item2 = Fabricate(:queue_item, user: tifa, position: 3)
      queue_item3 = Fabricate(:queue_item, user: tifa, position: 1)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item3, queue_item1, queue_item2])
    end

    it_behaves_like "require_sign_in" do
      let (:action) { get :index }
    end
  end

  describe "POST create" do
    before { set_current_user }

    it "redirects to my queue page" do
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      post :create, video_id: Fabricate(:video).id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item associated with the video" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item associated with the sign in user" do
      tifa = current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(tifa)
    end

    it "puts the video as the last one in the queue" do
      tifa = current_user
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: tifa)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: tifa.id).first
      expect(video2_queue_item.position).to eq(2)
    end

    it "adds the video only once in the queue" do
      tifa = current_user
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: tifa )
      post :create, video_id: video.id
      expect(tifa.queue_items.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let (:action) { post :create, video_id: 1 }
    end
  end

  describe "DELETE destroy" do
    before { set_current_user }

    it "redirects to my queue page" do
      set_current_user
      delete :destroy, id: Fabricate(:queue_item)
      expect(response).to redirect_to my_queue_path
    end

    it "delete the queue item" do
      tifa = current_user
      queue_item = Fabricate(:queue_item, user: tifa)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      tifa = current_user
      queue_item1 = Fabricate(:queue_item, user: tifa, position: 1)
      queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not delete the queue item if the current user is not the owner" do
      tifa = current_user
      yuri = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: yuri)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let (:action) { delete :destroy, id: 1 }
    end
  end

  describe "POST udpate_queue" do
    
    it_behaves_like "require_sign_in" do
      let (:action) { post :update_queue, queue_items: [{id: 1, position: 1}, {id: 2, position: 2}] }
    end

    context "with valid inputs" do
      let (:tifa) { Fabricate(:user) }
      let (:queue_item1) { Fabricate(:queue_item, user: tifa, position: 1) }
      let (:queue_item2) { Fabricate(:queue_item, user: tifa, position: 2) }

      before do
        session[:user_id] = tifa.id
      end

      it "redirects to my_queue_path" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(tifa.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(tifa.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let (:tifa) { Fabricate(:user) }
      let (:queue_item1) { Fabricate(:queue_item, user: tifa, position: 1) }
      let (:queue_item2) { Fabricate(:queue_item, user: tifa, position: 2) }

      before do
        session[:user_id] = tifa.id
      end
      
      it "redirects to my_queue_path" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.2}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "does not change the queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.5}]
        expect(queue_item1.reload.position).to eq(1)
      end

      it "shows error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.2}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end
    end

    context "with queue items that do not belongs to the current user" do
      it "does not change the queue items" do
        set_current_user
        tifa = current_user
        bob = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
        queue_item2 = Fabricate(:queue_item, user: tifa, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end