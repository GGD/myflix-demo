require 'spec_helper'

describe Video do
  before :each do
    @video = Video.new(title: 'Monk', description: 'Moooooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
  end

  it "save itself" do
    @video.save
    Video.first.title.should == 'Monk'
  end

  it "belongs to category" do
    category = Category.new(name: 'TV Commedies')
    category.save
    @video.save
    @video.category_id.should == category.id
  end

  it "require a title" do
    @video.title = nil
    @video.should_not be_valid
  end

  it "require a description" do
    @video.description = nil
    @video.should_not be_valid
  end
end