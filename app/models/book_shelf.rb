class BookShelf < ApplicationRecord
  # 本棚を削除した時中に入っていた書籍の本棚idをnull更新
  has_many :user_titles, dependent: :nullify
  belongs_to :user
end
