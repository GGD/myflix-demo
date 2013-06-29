require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let (:action) { get :index }
    end

    it "assigns @relationships to the current user's following relationships" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let (:action) { delete :destroy, id: 1 }
    end

    it "redirects to people page" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if current user is the follower" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if current user is not the follower" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      bob = Fabricate(:user)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: ted)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let (:action) { post :create, leader_id: 1 }
    end

    it "redirects to people page" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      post :create, leader_id: ted.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      post :create, leader_id: ted.id
      expect(tifa.following_relationships.first.leader).to eq(ted)
    end

    it "does not create a relationship if the current user already follows the leader" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      post :create, leader_id: ted.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow themselves" do
      tifa = Fabricate(:user)
      set_current_user(tifa)
      post :create, leader_id: tifa.id
      expect(Relationship.count).to eq(0)
    end
  end
end