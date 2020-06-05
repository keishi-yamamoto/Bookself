class Users::UserTitlesController < ApplicationController
  def new
    @title = params[:title]
    @id = params[:id]
    # 新規タイトル登録のときのみ重複しているか検索する
    if @id = "null" && Title.find_by(name: @title).present?
      @id = Title.find_by(name: @title).id
    end
    UserTitle.new
  end
end
