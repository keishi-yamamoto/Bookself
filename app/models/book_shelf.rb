class BookShelf < ApplicationRecord
  has_many :user_titles
  belongs_to :user
end
