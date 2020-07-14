class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :book_shelves, dependent: :destroy
  # 退会しても本に対するpostは残る
  has_many :posts, dependent: :nullify
  has_many :user_titles, dependent: :destroy

  validates :name, length: { maximum: 20 }
  validates :elastic_id, uniqueness: true 

    # フォロー機能部分
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  # 所持書籍合計
  def total_books
    results = 0
    user_titles.each do |user_title|
      results += user_title.volumes.count
    end
    results
  end

  # home/notificationに表示するためのコンテンツ
  def contents
    # 自分のuser_titles
    contents = user_titles
    # 自分のfollowerのUserTitle(本棚が公開のもの)
    contents += UserTitle.joins(:user).where(users:{id:following_user}).joins(:book_shelf).where(book_shelves: {is_public: true})
    contents = contents.sort_by {|v| v.created_at}
    contents.reverse
  end

  # 公開設定になっている全ての本棚に含まれるuser_titles
  def public_user_titles
    UserTitles.joins(:book_shelf).where(book_shelves: {is_public: true})
  end
end
