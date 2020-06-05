class Users::UserTitlesController < ApplicationController
  def new
    if params[:option] = "new"
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
    else
      @book = Title.find_by(params[:id])
    end
    @user_title = current_user.user_titles.new
  end
end
