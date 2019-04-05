class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
  validates :name, presence: true, uniqueness: true
  
  
  def show_posts page = 1
    self.posts.published.ordered.page(page).per(5).map{|post| post.show}
  end
end
