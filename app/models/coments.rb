class Coments < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  validates :text, presence: true
  
  scope :ordered, -> {order(created_at: :desc)}
  
  def self.create user, post, coment_params
    comment = user.coments.new(coment_params)
    comment.post = post
    comment
  end
  
  def show
    {
      text: self.text,
      username: self.user.nickname,
      date: self.created_at
    }
  end
  
end
