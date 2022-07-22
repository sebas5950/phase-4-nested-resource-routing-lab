class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
      byebug
    end
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(strong_params)
    render json: item, status: :created
  end

  def show
    user = User.find(params[:user_id])
    item = user.items.find(params[:id])
    render json: item
  end

  private

  def strong_params
    params.permit(:name, :description, :price)
  end

  def render_not_found
    render json: { error: "Item not found" }, status: :not_found
  end

end
