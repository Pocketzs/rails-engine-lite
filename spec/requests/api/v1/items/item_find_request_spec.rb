require 'rails_helper'

RSpec.describe 'Item Find API' do
  describe 'find a single item which matches a search term' do
    it 'will return an item if the name matches' do
      item = create(:item, name: "Item")

      # get "/api/v1/items/find", params: { name: 'Item'}
      get "/api/v1/items/find?name=#{item.name}"
      # get "/api/v1/items/find?name="

      expect(response).to have_http_status(:ok)

      item_json = JSON.parse(response.body, symbolize_names:true)

      item_data = item_json[:data]

      expect(item_data).to be_a(Hash)

      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)
      
      expect(item_data).to have_key(:type)
      expect(item_data[:type]).to eq("item")

      expect(item_data).to have_key(:attributes)
      expect(item_data[:attributes]).to be_a(Hash)

      attributes = item_data[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(item.name)
      
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
     
      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
      
      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end
