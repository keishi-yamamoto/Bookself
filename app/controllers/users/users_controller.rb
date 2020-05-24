class Users::UsersController < ApplicationController
  def top
  end

  def show
  end

  def edit
  end

  def search_id
    # 同じelastic_idが存在するかどうかでtrue/falseを返す
    result = User.find_by(elastic_id: params[:q]).present?
    byebug
    render json: {result: result}
  end
end
