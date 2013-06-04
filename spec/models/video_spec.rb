require 'spec_helper'

describe Video do
  it "save itself" do
    video = Video.new(title: 'Monk', description: 'Moooooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
    video.save
    Video.first.title.should == 'Monk'
  end
end