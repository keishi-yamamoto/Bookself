class BookShelf < ApplicationRecord
  belongs_to :user
  has_many :book_series
end
