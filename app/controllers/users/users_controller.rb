class Users::UsersController < ApplicationController
  def top
  end
  
  def search_id
    result = User.find_by(elastic_id: params[:id]).present?
    render json: result
  end

  def search_mail
    result = User.find_by(email: params[:email]).present?
    render json: result
  end

  def show
  end

  def edit
  end
end
