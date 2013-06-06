require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#self.search_by_title" do
    before :each do
      Video.create(title: 'Monk', description: 'Moooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
      Video.create(title: 'SouthPark', description: 'south_park', large_cover: '/tmp/south_pard.jpg', small_cover: '/tmp/south_park.jpg', category_id: '2')
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
end