class UserTitle < ApplicationRecord
  belongs_to :book_shelf
  belongs_to :title
end
