class BookSeries < ApplicationRecord
  belongs_to :book_shelf
  has_many :books
end
