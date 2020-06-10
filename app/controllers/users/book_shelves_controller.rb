class Users::BookShelvesController < ApplicationController
  def index
    @book_shelves = current_user.book_shelves
    # 本棚が削除されたままでどの本棚にも入っていない書籍
    @lost_titles = current_user.user_titles.where(book_shelf_id: nil)
    @book_shelf = BookShelf.new
  end

  def create
    current_user.book_shelves.create!(name: params[:book_shelf][:name])
    redirect_to book_shelves_path
  end

  def show
    @book_shelf = BookShelf.find(params[:id])
    @user_titles = @book_shelf.user_titles
  end

  # 本棚に入っていない書籍を入れてある本棚
  def nil
    @user_titles = current_user.user_titles.where(book_shelf_id: nil)
  end

  def update
    @book_shelf = BookShelf.find(params[:id])
    @book_shelf.update(name: params[:book_shelf][:name])
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
end
