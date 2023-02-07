require 'rails_helper'

RSpec.describe "Items API" do
  describe 'fetch all items' do
    it 'sends a list of items' do
      merchant1,merchant2 = create_list(:merchant, 2)
      items1 = create_list(:item, 2, merchant: merchant1)
      items2 = create_list(:item, 2, merchant: merchant2)

      get "/api/v1/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      items_data = items[:data]

      expect(items_data.count).to eq(4)
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
      end
      # require 'pry'; binding.pry
    end

    it 'returns an array if there is only 1 resource' do
      merchant = create(:merchant)
      create(:item, merchant: merchant)
      get "/api/v1/items"
  
      expect(response).to be_successful
  
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      
      expect(items_data.count).to eq(1)
      expect(items_data).to be_a(Array)
    end

    it 'returns an array if no resources are found' do
      get "/api/v1/items"
  
      expect(response).to be_successful
  
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      
      expect(items_data.count).to eq(0)
      expect(items_data).to be_a(Array)
    end

    it 'does NOT include dependent resources' do
      merchant = create(:merchant)
      create(:item, merchant: merchant)
      get "/api/v1/items"

      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data].first

      expect(items_data.keys).to_not include(:relationships)
    end
  end
end