class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :book_shelves, dependent: :destroy
  # 退会しても本に対するpostは残る
  has_many :posts, dependent: :nullify
end
