class Api::V1::MerchantItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
    render json: MerchantItemSerializer.new(items)
  end
end