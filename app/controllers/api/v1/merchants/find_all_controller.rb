class Api::V1::Merchants::FindAllController < ApplicationController
  def index
    merchant = Merchant.find_merchants_by_name(params[:name])
    render json: MerchantSerializer.new(merchant)
  end
end