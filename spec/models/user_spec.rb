require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it "generates a random token when the user is created" do
    tifa = Fabricate(:user)
    expect(tifa.token).to be_present
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
end