class Book < ApplicationRecord
  has_many :posts
  belongs_to :book_series
end
