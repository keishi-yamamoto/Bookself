class Users::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:top, :search, :show]

  def top
    @new_titles = Title.all.order('id desc').take(10)
  end

  def search
    # 登録書籍からユーザを検索する
    @title = Title.find(params[:title_id])
    @user_titles = @title.user_titles.order('id desc')
  end

  def show
    @user = User.find(params[:id])
    @book_shelves = @user.book_shelves.where(is_public: true)
  end

  def edit
  end

  def update
  end
  
  def destroy
  end

  private
  def search_id
    result = User.find_by(elastic_id: params[:id]).present?
    render json: result
  end

  def search_mail
    result = User.find_by(email: params[:email]).present?
    render json: result
  end
end
