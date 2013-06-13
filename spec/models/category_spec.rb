require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_vidoes" do
    before :each do
      @category = Category.create(name: 'TV shows')
      Video.create(title: 'First video', description: 'first', category_id: '1')
      Video.create(title: 'Second video', description: 'second', category_id: '1')
      Video.create(title: 'Third video', description: 'third', category_id: '1')
    end

    it "return all videos if recent videos are less than 6" do
      expect(@category.recent_videos).to have(3).videos
    end

    it "return 6 videos if recent videos is equal to or more than 6" do
      Video.create(title: 'Fourth video', description: 'fourth', category_id: '1')
      Video.create(title: 'Fifth video', description: 'fifth', category_id: '1')
      Video.create(title: 'Sixth video', description: 'sixth', category_id: '1')
      Video.create(title: 'Seventh video', description: 'seventh', category_id: '1')
      expect(@category.recent_videos).to have_at_most(6).videos
    end

    it "return videos by descending id" do
      expect(@category.recent_videos.first.title).to match(/Third/)
    end
  end
end