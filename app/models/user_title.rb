class UserTitle < ApplicationRecord
  belongs_to :user
  belongs_to :title
  belongs_to :book_shelf
end
