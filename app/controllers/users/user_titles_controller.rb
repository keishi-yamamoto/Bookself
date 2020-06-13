class Users::UserTitlesController < ApplicationController
  before_action :authenticate_user!, except: [:index_other, :show]

  def index
    @user_titles = current_user.user_titles.order('book_shelf_id desc')
  end

  def index_other
    @user = User.find(params[:user_id])
    @user_titles = @user.user_titles.joins(:book_shelf).where(book_shelves: {is_public: true}).order('book_shelf_id desc')
  end

  def show
    @user_title = UserTitle.find(params[:id])
    max = @user_title.volumes.max
    # 10巻区切りにした場合の区切り個数と最後の区切りにおける巻数
    @title_count = [@user_title.volumes.max.fdiv(10).ceil, max - (max / 10) * 10]
    # maxが10の倍数の際には10巻とする
    if @title_count[1] == 0
      @title_count[1] = 10
    end
    # current_userのみ編集もできるように
    if  user_signed_in? && current_user.book_shelves.present?
      @book_shelves = current_user.book_shelves
    end
  end

  def new
    # 新規登録書籍かどうかの分岐
    if params[:id]
      @book = Title.find(params[:id])
      if current_user.user_titles.find_by(title_id: @book.id).present?
        redirect_to user_title_path(current_user.user_titles.find_by(title_id: @book.id))
      end
    else
      @title = params[:title]
      # 登録する書籍が既に存在するかどうかチェック
      if Title.find_by(name: @title).present?
        @book = Title.find_by(name: @title)
      else
        # API検索結果による元の書籍名
        @row_title = params[:row_title]
        # 新規タイトル作成
        @book = Title.new(
          name: params[:title],
          author: params[:author],
          publisher: params[:publisher],
        )
      end
    end
    @user_title = UserTitle.new
    # ユーザが本棚を持っているかどうか
    if current_user.book_shelves.present?
      @book_shelves = current_user.book_shelves
    end
  end

  def create
    # 本棚に関する操作
    # ユーザが既存の本棚を選択した場合
    if params[:option] == "choice"
      @book_shelf = BookShelf.find(params[:BookShelf][:chosen_id])
    # 本棚が存在しない場合、存在するが新しい本棚を作るを選択した場合
    else
      current_user.book_shelves.create!(name: params[:name])
      @book_shelf = current_user.book_shelves.last
    end
    # 登録する書籍に関する操作
    # DB内に既存の書籍の場合
    if params[:user_title][:id]
      @title = Title.find(params[:user_title][:id])
    # DB内に存在せず、新規登録する書籍の場合
    else
      Title.create!(
        name: params[:user_title][:name],
        author: params[:user_title][:author],
        publisher: params[:user_title][:publisher]
      )
      @title = Title.last
    end
    # 所持巻数の入力
    start_vol = params[:start_vol].to_i
    end_vol = params[:end_vol].to_i
    vol = [*start_vol..end_vol]
    current_user.user_titles.create!(
      book_shelf_id: @book_shelf.id,
      title_id: @title.id,
      volume: vol.to_json
    )
    redirect_to book_shelves_path
  end

  def update
    @user_title = UserTitle.find(params[:id])
    numbers = JSON.parse(params[:numbers])
    # 新しい最終巻
    new_max = numbers.rindex(1) + 1
    vol = []
    i = 1
    new_max.times do
      if numbers[i - 1] == 1
        vol.push(i)
      end
      i += 1
    end
    unless params[:end_vol] == ""
      # 新規追加巻数の最終巻
      end_vol = params[:end_vol].to_i
      vol.push(*(@user_title.volumes.max + 1)..end_vol)
    end
    if params[:option] == "choice"
      @book_shelf = BookShelf.find(params[:user_title][:book_shelf_id])
    else
      current_user.book_shelves.create!(name: params[:name])
      @book_shelf = current_user.book_shelves.last
    end
    @user_title.update(
      book_shelf_id: @book_shelf.id,
      volume: vol.to_json)
    redirect_to user_titles_path
  end

  def update_all
    @book_shelf =  BookShelf.find(params[:BookShelf][:chosen_id])
    change_flags = JSON.parse(params[:numbers])
    i = 0
    change_flags.count.times do
      if change_flags[i][1] == 1
        UserTitle.find(change_flags[i][0]).update(book_shelf_id: @book_shelf.id)
      end
      i += 1
    end
    redirect_to user_titles_path
  end

  def destroy
    @user_title = UserTitle.find(params[:id])
    @user_title.destroy!
    redirect_to user_titles_path
  end
end
