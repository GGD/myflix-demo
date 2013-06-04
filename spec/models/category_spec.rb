require 'spec_helper'

describe Category do
  before :each do
    @category = Category.new(name: 'TV Commedies')
  end

  it "save itself" do
    @category.save
    Category.first.name.should == 'TV Commedies'
  end

  it "has many videos" do
    @category.save
    video1 = Video.new(title: 'Monk', description: 'Moooooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
    video2 = Video.new(title: 'Terminator', description: 'Ill be back', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
    video1.save
    video2.save
    @category.videos.size.should == 2
  end
end