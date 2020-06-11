class Users::BookShelvesController < ApplicationController
  before_action :authenticate_user!, except: [:index_other, :show_other]

  def index
    @book_shelves = current_user.book_shelves
    # 本棚が削除されたままでどの本棚にも入っていない書籍
    @lost_titles = current_user.user_titles.where(book_shelf_id: nil)
    @book_shelf = BookShelf.new
  end

  def index_other
    @user = User.find(params[:user_id])
    @book_shelves = @user.book_shelves.where(is_public: true)
  end

  def create
    # nilから来た場合
    if params[:numbers]
      @book_shelf =  BookShelf.find(params[:BookShelf][:chosen_id])
      change_flags = JSON.parse(params[:numbers])
      i = 0
      change_flags.count.times do
        if change_flags[i][1] == 1
          UserTitle.find(change_flags[i][0]).update(book_shelf_id: @book_shelf.id)
        end
        i += 1
      end
      redirect_to book_shelf_path(@book_shelf)
    else
      current_user.book_shelves.create!(name: params[:book_shelf][:name])
      redirect_to book_shelves_path
    end
  end

  def show
    @book_shelf = BookShelf.find(params[:id])
    if current_user == @book_shelf.user
      # 現在の本棚に入っている書籍
      @user_titles_this = @book_shelf.user_titles
      # それ以外の書籍を取り出し、本棚順にソートする
      @user_titles_others = current_user.user_titles.where.not(book_shelf_id: @book_shelf.id).order("book_shelf_id desc")
      # 本棚未登録の本
      @user_titles_nil = current_user.user_titles.where(book_shelf_id: nil) 
    else
      flash[:notice] == "アクセス権がありません"
      redirect_to root_path
    end
  end

  # is_public: trueの他人の本棚詳細画面
  def show_other
    @book_shelf = BookShelf.find(params[:id])
    if @book_shelf.is_public
      @user_titles = @book_shelf.user_titles
    else
      flash[:notice] = "入力されたidの本棚は非公開設定です"
      redirect_to root_path
    end
  end

  # 本棚に入っていない書籍を入れてある本棚
  def nil
    @book_shelf = BookShelf.new
    @user_titles_this = current_user.user_titles.where(book_shelf_id: nil)
    @user_titles_others = current_user.user_titles.where.not(book_shelf_id: nil).order("book_shelf_id desc")
  end

  def update
    # 本棚更新アクション
    @book_shelf = BookShelf.find(params[:id])
    @book_shelf.update(book_shelf_params)
    # 登録書籍一括変更アクション
    change_flags = JSON.parse(params[:numbers])
    # 元々本棚に登録されていた書籍数
    default_titles = @book_shelf.user_titles.ids.count
    i = 0
    # チェックが外されていたら未登録書籍に移動する
    default_titles.times do
      if change_flags[i][1] == 0
        UserTitle.find(change_flags[i][0]).update(book_shelf_id: nil)
      end
      i += 1
    end
    # チェックされていたらこの本棚に登録する
    (change_flags.count - default_titles).times do
      if change_flags[i][1] == 1
        UserTitle.find(change_flags[i][0]).update(book_shelf_id: @book_shelf.id)
      end
      i += 1
    end
    redirect_to book_shelf_path(@book_shelf)
  end

  def destroy
    BookShelf.find(params[:id]).destroy!
    redirect_to book_shelves_path
  end

  def destroy_all
    current_user.book_shelves.destroy_all
    redirect_to book_shelves_path
  end

  private
  def book_shelf_params
    params.require(:book_shelf).permit(:id, :name, :is_public)
  end
end
