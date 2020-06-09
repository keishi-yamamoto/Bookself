class Title < ApplicationRecord
  has_many :books
  has_many :user_titles

end
