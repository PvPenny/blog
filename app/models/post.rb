class Post < ApplicationRecord
  belongs_to :user
  has_many :coments
  has_and_belongs_to_many :tags
end
