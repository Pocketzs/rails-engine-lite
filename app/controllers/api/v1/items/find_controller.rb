class Api::V1::Items::FindController < ApplicationController
  def index
    # require 'pry'; binding.pry
    item = Item.find_item_by_name(params[:name])
    render json: ItemSerializer.new(item)
  end
end