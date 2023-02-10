require 'rails_helper'

RSpec.describe 'Merchant Find All API' do
  describe 'happy' do
    it 'returns all merchants that match name' do
      merchant1 = create(:merchant, name: 'Walmart')
      merchant2 = create(:merchant, name: 'Allmart')

      get "/api/v1/merchants/find_all?name=MaRt"

      expect(response).to have_http_status(:ok)

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchants[:data]
      
      expect(merchant_data.count).to eq(2)
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
  end
end