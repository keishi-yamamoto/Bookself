class Users::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def top
    @new_titles = Title.all.order('id desc').take(10)
  end

  def about
  end

  def search
    # 登録書籍からユーザを検索する
    @title = Title.find(params[:title_id])
    @user_titles = @title.user_titles.order('id desc')
  end

  def show
    @user = User.find(params[:id])
    @book_shelves = @user.book_shelves.where(is_public: true)
    @user_titles = @user.user_titles.joins(:book_shelf).where(book_shelves: {is_public: true})
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      flash[:notice] = "アクセス権がありません"
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    flash[:notice] = "ユーザ情報が変更されました"
    redirect_to user_path(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  def search_id
    result = User.find_by(elastic_id: params[:id]).present?
    render json: result
  end

  def search_mail
    result = User.find_by(email: params[:email]).present?
    render json: result
  end

  private
  def user_params
    params.require(:user).permit(:id, :name, :elastic_id, :email, :encrypted_password)
  end
end
