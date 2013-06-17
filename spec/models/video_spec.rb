require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe "#self.search_by_title" do
    before :each do
      Video.create(title: 'Monk', description: 'Moooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
      Video.create(title: 'SouthPark', description: 'south_park', large_cover: '/tmp/south_pard.jpg', small_cover: '/tmp/south_park.jpg', category_id: '2')
    end

    it "return empty array if searching string is empty" do
      expect(Video.search_by_title("")).to eq([])
    end

    it "return empty array if video is not found" do
      search_term = "Superman"
      expect(Video.search_by_title(search_term)).to eq([])
    end
    it "return videos if title is matched with searching string" do
      search_term = "k"
      videos = Video.all
      expect(Video.search_by_title(search_term)).to eq(videos)
    end
  end

  describe "#average_rating" do
    let (:video) { Fabricate(:video) }

    it "returns one decimal place of the average rating" do
      review1 = Fabricate(:review, rating: 4, video: video)
      review2 = Fabricate(:review, rating: 5, video: video)
      review3 = Fabricate(:review, rating: 1, video: video)
      expect(video.average_rating).to eq(3.3)
    end

    it "count each reviewer's rating only the last time" do
      tifa = Fabricate(:user)
      tifa_review1 = Fabricate(:review, rating: 5, video: video, user: tifa)
      tifa_review2 = Fabricate(:review, rating: 3, video: video, user: tifa)
      expect(video.average_rating).to eq(3.0)
    end
  end
end