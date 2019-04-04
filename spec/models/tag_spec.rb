require 'rails_helper'

RSpec.describe Tag, type: :model do
  after do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  before do
    @tag = create(:post)
  end
  
  it 'should create post' do
    Tag.last.should eql @tag
  end
  
  it 'should raise error if no name' do
    @tag.name = nil
    @tag.should_not be_valid
    @tag.errors[:name].should_not be_nil
  end
end
