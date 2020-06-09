class UserTitle < ApplicationRecord
  belongs_to :user
  belongs_to :title
  belongs_to :book_shelf

  # :volumeがjson形式になっているのでそれを配列に戻す
  def volumes
    JSON.parse(volume)
  end
end
