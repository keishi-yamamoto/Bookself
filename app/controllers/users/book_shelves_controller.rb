class Users::BookShelvesController < ApplicationController
  def index
    @book_shelves = current_user.book_shelves
  end

  def show
  end

  def destroy
    BookShelf.find(params[:id]).destroy!
    redirect_to book_shelves_path
  end
end
