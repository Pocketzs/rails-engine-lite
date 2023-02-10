class Api::V1::Items::FindController < ApplicationController
  def index
    if params[:name] && (params[:min_price].nil? && params[:max_price].nil?)
      item = Item.find_item_by_name(params[:name])
      render json: ItemSerializer.new(item)
    elsif (params[:min_price] || params[:max_price]) && params[:name].nil?
      item = Item.find_item_by_unit_price(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(item)
    else
      raise ActiveRecord::RecordInvalid
    end
  end
end