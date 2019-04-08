class Post < ApplicationRecord
  belongs_to :user
  has_many :coments, class_name: 'Coments'
  has_and_belongs_to_many :tags

  validates :text, presence: true
  scope :published, ->{ where(published: true)}
  scope :ordered, ->{ order(publish_date: :desc)}
  
  def self.prepare_for_index posts
    posts.map{|post| post.show}
  end
  
  def show
    {
      id: self.id,
      text: self.text,
      date: self.publish_date,
      username: self.user.nickname,
      published: self.published
    }
  end
  
  def self.create user, params
   post = user.posts.new(params.slice(:text, :published))
   params[:tags].each do |tag|
     current_tag = Tag.find_or_create_by(name: tag.squish)
     post.tags << current_tag
   end if params[:tags].present?
   post
  end
  
  def self.update post, params
    post.tags.clear
    params[:tags].each do |tag|
      current_tag = Tag.find_or_create_by(name: tag.squish)
      post.tags << current_tag
    end if params[:tags].present?
    post.update(params.slice(:text, :published))
  end
  
end
