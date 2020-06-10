class UserTitle < ApplicationRecord
  belongs_to :user
  belongs_to :title
  belongs_to :book_shelf

  # :volumeがjson形式になっているのでそれを配列に戻す
  def volumes
    JSON.parse(volume)
  end

  # 抜けている巻数を配列にする
  def volumes_shortage
    [*1..volumes.max] - volumes
  end
end
