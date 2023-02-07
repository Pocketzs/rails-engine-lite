require 'rails_helper'

RSpec.describe "Merchants API" do
  describe 'fetch all merchants' do
    it 'sends a list of merchants' do
      create_list(:merchant, 5)
  
      get "/api/v1/merchants"
  
      expect(response).to be_successful
  
      merchants = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry
      
      expect(merchants.count).to eq(5)
      expect(merchants).to be_a(Array)
  
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(Integer)
  
        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
      end
    end

    it 'returns an array if there is only 1 resource' do
      create(:merchant)
      get "/api/v1/merchants"
  
      expect(response).to be_successful
  
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchants.count).to eq(1)
      expect(merchants).to be_a(Array)
    end

    it 'returns an array if no resources are found' do
      get "/api/v1/merchants"
  
      expect(response).to be_successful
  
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchants.count).to eq(0)
      expect(merchants).to be_a(Array)
    end
  end
end