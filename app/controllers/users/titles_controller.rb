class Users::TitlesController < ApplicationController
  def index
    @titles = Title.all
  end

end
