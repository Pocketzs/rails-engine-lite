class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    # require 'pry'; binding.pry
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end