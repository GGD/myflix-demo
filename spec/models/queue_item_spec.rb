require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#by_position" do
    it "returns queue items by descending position" do
      queue_item1 = Fabricate(:queue_item, position: 1)
      queue_item2 = Fabricate(:queue_item, position: 2)
      queue_item3 = Fabricate(:queue_item, position: 3)
      expect(QueueItem.by_position).to eq([queue_item1, queue_item2, queue_item3])
    end
  end

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'Monk')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('Monk')
    end
  end

  describe "#rating" do
    it "returns the rating from review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, rating: 4, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil from review when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category_name" do
    it "returns the name of category" do
      category = Fabricate(:category, name: 'comedies')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('comedies') 
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category) 
    end
  end

  describe "#reorder_position" do
    before do
      queue_item1 = Fabricate(:queue_item, position: 1)
      queue_item2 = Fabricate(:queue_item, position: 2)
      queue_item3 = Fabricate(:queue_item, position: 3)
    end

    it "updates the queue_items position for explicit orders" do
      ids_with_order = {"1" => 3, "2" => 2, "3" => 1}
      QueueItem.reorder_position(ids_with_order)
      expect(QueueItem.first.position).to eq(3)
    end

    it "updates the queue_items position started from 1" do
      ids_with_order = {"1" => -1, "2" => 3, "3" => 5}
      QueueItem.reorder_position(ids_with_order)
      expect(QueueItem.first.position).to eq(1)
    end
  end
end