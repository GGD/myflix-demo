require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(name: 'TV Commedies')
    category.save
    Category.first.name.should == 'TV Commedies'
  end

  it { should have_many(:videos) }
end