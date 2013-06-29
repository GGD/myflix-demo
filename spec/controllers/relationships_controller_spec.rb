require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let (:action) { get :index }
    end

    it "assigns @relationships to the current user's following relationships" do
      set_current_user
      tifa = current_user
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
      set_current_user
      tifa = current_user
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if current user is the follower" do
      set_current_user
      tifa = current_user
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tifa, leader: ted)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if current user is not the follower" do
      set_current_user
      tifa = current_user
      bob = Fabricate(:user)
      ted = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: ted)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end