class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :book_shelves, dependent: :destroy
  # 退会しても本に対するpostは残る
  has_many :posts, dependent: :nullify
  has_many :user_titles, dependent: :destroy

  # 所持書籍合計
  def total_books
    results = 0
    user_titles.each do |user_title|
      results += user_title.volumes.count
    end
    results
  end
end
