class UserTitle < ApplicationRecord
  belongs_to :user
  belongs_to :title
  has_many :book_shelves
end
