require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#follow?" do
    it "returns true if the user has a following relationship with the leader" do
      tifa = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: tifa, leader: bob)
      expect(tifa.follow?(bob)).to be_true
    end

    it "returns false if the user does not have a following relationship with the leader" do
      tifa = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: bob, leader: tifa)
      expect(tifa.follow?(bob)).to be_false
    end
  end

  describe "#follow" do
    it "follows the leader" do
      tifa = Fabricate(:user)
      bob = Fabricate(:user)
      tifa.follow(bob)
      expect(tifa.follow?(bob)).to be_true
    end

    it "does not follow one self" do
      tifa = Fabricate(:user)
      tifa.follow(tifa)
      expect(tifa.follow?(tifa)).to be_false
    end
  end

  describe "#deactivcate!" do
    it "deactivcates an active user" do
      tifa = Fabricate(:user, active: true)
      tifa.deactivate!
      expect(tifa).not_to be_active
    end
  end
end
