require 'rails_helper'

RSpec.describe Coments, type: :model do
  
  after do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  before do
    @coment = create(:coment)
  end
  
  it 'should create coment' do
    Coments.last.should eql @coment
  end
  
  it 'should have post' do
    @coment.post.should_not be_nil
  end

  it 'should have user' do
    @coment.user.should_not be_nil
  end
  
  it 'should raise error if no text' do
    @coment.text = nil
    @coment.should_not be_valid
    @coment.errors[:text].should_not be_nil
  end
  
end
