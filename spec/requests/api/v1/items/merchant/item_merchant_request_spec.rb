require 'rails_helper'

RSpec.describe 'Item Merchant API' do
  describe 'fetch items merchant' do
    it 'returns the merchant associated with an item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to have_http_status(:ok)

      merchant = JSON.parse(response.body, symbolize_names:true)

      merchant_data = merchant[:data]

      expect(merchant_data).to be_a(Hash)

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_a(String)
      
      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to eq("merchant")

      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)

      attributes = merchant_data[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end

    it 'returns error if item id doesnt exit' do
      get "/api/v1/items/1/merchant"

      expect(response).to have_http_status(:not_found)
      error_json = JSON.parse(response.body, symbolize_names:true)

      expect(error_json[:errors].first[:detail]).to eq("Couldn't find Item with 'id'=1")
    end
  end
end