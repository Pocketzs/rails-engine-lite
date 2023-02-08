class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    # require 'pry'; binding.pry
    item = Item.create!(item_params)
    render json: CreatedItemSerializer.new(item), status: :created
  end

  def update
    # require 'pry'; binding.pry
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: CreatedItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.delete
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end