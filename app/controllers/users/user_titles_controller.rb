class Users::UserTitlesController < ApplicationController
  def index
    @user_titles = current_user.user_titles
  end

  def show
    @user_title = UserTitle.find(params[:id])
  end

  def new
    # 新規登録書籍かどうかの分岐
    if params[:id]
      @book = Title.find(params[:id])
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
    if params[:option] == "new"
      current_user.book_shelves.create!(name: params[:name])
      @book_shelf = current_user.book_shelves.last
    else
      @book_shelf = BookShelf.find(params[:user_title][:book_shelf_id])
    end
      UserTitle.find(params[:id]).update(book_shelf_id: @book_shelf.id)
    redirect_to user_titles_path
  end
end
