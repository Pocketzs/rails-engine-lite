require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  describe 'fetch all merchant items' do
    it 'returns all items associated with a merchant' do
      merchant = create(:merchant)
      item1,item2,item3 = create_list(:item, 3, merchant:merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to have_http_status(:ok)

      items = JSON.parse(response.body, symbolize_names:true)

      items_data = items[:data]

      expect(items_data.count).to eq(3)
      expect(items_data).to be_a(Array)

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:type)
        expect(item[:type]).to eq("item")

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'returns 404 if merchant is not found' do
      get "/api/v1/merchants/1/items"

      expect(response).to have_http_status(:not_found)

      error_json = JSON.parse(response.body, symbolize_names:true)
      expect(error_json[:errors].first[:detail]).to eq("Couldn't find Merchant with 'id'=1")
    end

    it 'returns an array if there is only 1 resource' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to have_http_status(:ok)

      items = JSON.parse(response.body, symbolize_names:true)
      items_data = items[:data]

      expect(items_data.count).to eq(1)
      expect(items_data).to be_a(Array)
    end

    it 'returns an array if no resources are found' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to have_http_status(:ok)

      items = JSON.parse(response.body, symbolize_names:true)
      items_data = items[:data]

      expect(items_data.count).to eq(0)
      expect(items_data).to be_a(Array)
    end
  end
end