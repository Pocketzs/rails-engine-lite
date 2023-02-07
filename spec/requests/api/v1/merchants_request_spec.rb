require 'rails_helper'

RSpec.describe "Merchants API" do
  describe 'fetch all merchants' do
    it 'sends a list of merchants' do
      create_list(:merchant, 5)
  
      get "/api/v1/merchants"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      merchants = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry
      merchant_data = merchants[:data]
      
      expect(merchant_data.count).to eq(5)
      expect(merchant_data).to be_a(Array)
  
      merchant_data.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")
  
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns an array if there is only 1 resource' do
      create(:merchant)
      get "/api/v1/merchants"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchants[:data]
      
      expect(merchant_data.count).to eq(1)
      expect(merchant_data).to be_a(Array)
    end

    it 'returns an array if no resources are found' do
      get "/api/v1/merchants"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchants[:data]
      
      expect(merchant_data.count).to eq(0)
      expect(merchant_data).to be_a(Array)
    end

    it 'does NOT include dependent resources' do
      create(:merchant)
      get "/api/v1/merchants"

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchants[:data].first

      expect(merchant_data.keys).to_not include(:relationships)
    end
  end
end