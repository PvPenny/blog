require 'rails_helper'

RSpec.describe Post, type: :model do
  after do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  before do
    @post = create(:post)
  end
  
  it 'should create post' do
    Post.last.should eql @post
  end
  
  it 'should be with tag' do
    @post.tags.count.should_not eql 0
  end

  it 'should have user' do
    @post.user.should_not be_nil
  end

  it 'not required tags' do
    @post.tags.clear
    @post.should be_valid
  end
  
  it 'should raise error if no text' do
    @post.text = nil
    @post.should_not be_valid
    @post.errors[:text].should_not be_nil
  end
  
  
  
end
