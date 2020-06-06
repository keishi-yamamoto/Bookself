class Users::UserTitlesController < ApplicationController
  def index
    @user_titles = current_user.user_titles
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
    @user_title = current_user.user_titles.new
    # ユーザが本棚を持っているかどうか
    if current_user.book_shelves.present?
      @book_shelves = current_user.book_shelves
    end
    @book_shelf = current_user.book_shelves.new
  end

  def create
    # 既存の本棚を選んだかどうか
    if params[:option] && params[:option] = "choice"
      byebug
    else
      current_user.book_shelves.create!(name: params[:name])
      @book_shelf = current_user.book_shelves.last
    end
    # DB内に既存の書籍の場合
    if params[:user_title][:id]
      id = params[:user_title][:id]
      current_user.user_titles.create!(title_id: id)
    end
    byebug
    redirect_to book_shelves_path
  end
end
