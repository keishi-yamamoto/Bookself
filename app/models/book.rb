class Book < ApplicationRecord
  has_many :posts
  belongs_to :title
end
