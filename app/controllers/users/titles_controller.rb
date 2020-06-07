class Users::TitlesController < ApplicationController
  def index
    @titles = Title.all
  end

  def new
    @title = Title.new
  end

  def create
    @title = Title.new(title_params)
    @title.save
    redirect_to titles_path
  end

  private
  def title_params
    params.require(:title).permit(:name, :author, :publisher, :total_amount)
  end
end
