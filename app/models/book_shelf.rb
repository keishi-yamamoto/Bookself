class BookShelf < ApplicationRecord
  belongs_to :user
  has_many :user_titles
end
