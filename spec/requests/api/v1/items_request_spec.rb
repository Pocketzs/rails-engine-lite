require 'rails_helper'

RSpec.describe "Items API" do
  describe 'fetch all items' do
    it 'sends a list of items' do
      merchant1,merchant2 = create_list(:merchant, 2)
      items1 = create_list(:item, 2, merchant: merchant1)
      items2 = create_list(:item, 2, merchant: merchant2)

      get "/api/v1/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

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
      expect(response.status).to eq(200)
  
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      
      expect(items_data.count).to eq(1)
      expect(items_data).to be_a(Array)
    end

    it 'returns an array if no resources are found' do
      get "/api/v1/items"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
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

  describe 'fetch a single item' do
    it 'returns a single item given an items id' do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)

      get "/api/v1/items/#{item1.id}"

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
      
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
     
      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
    end

    it 'returns error if item id doesnt exist' do
      get "/api/v1/items/1"

      error_json = JSON.parse(response.body, symbolize_names:true)
      # require 'pry'; binding.pry

      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
    end
  end

  describe 'create an item' do
    it 'can create a new item' do
      merchant1 = create(:merchant)
      item_params = {
        name: Faker::Games::ElderScrolls.weapon,
        description: "Good for killing #{Faker::Games::ElderScrolls.creature}",
        unit_price: 100.99,
        merchant_id: merchant1.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to have_http_status(:created)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])

      created_item_json = JSON.parse(response.body, symbolize_names:true)
      item_data = created_item_json[:data]
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
      
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
     
      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
      
      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end

    it 'returns error if item creation invalid' do
      merchant1 = create(:merchant)
      item_params = {
        name: '',
        description: '',
        unit_price: '',
        merchant_id: ''
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.status).to eq(422)
      
      error_json = JSON.parse(response.body, symbolize_names:true)
      expect(error_json[:errors].first[:detail]).to eq("Validation failed: Merchant must exist, Name can't be blank, Description can't be blank, Unit price can't be blank, Unit price is not a number")

      item_params = {
        name: 'name',
        description: 'description',
        unit_price: -1,
        merchant_id: merchant1.id
      }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      error_json = JSON.parse(response.body, symbolize_names:true)
      expect(error_json[:errors].first[:detail]).to eq("Validation failed: Unit price must be greater than or equal to 0")
    end
  end

  describe 'update an item' do
    it 'can update an exisiting item' do
      m1 = create(:merchant)
      m2 = create(:merchant)
      item1 = create(:item, name: 'old name', description: 'old description', unit_price: 1.5, merchant: m1)

      update_params = {
        name: "value1",
        description: "value2",
        unit_price: 100.99,
        merchant_id: m2.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate(item: update_params)

      expect(response).to have_http_status(:ok)

      updated_json = JSON.parse(response.body, symbolize_names:true)
      item_data = updated_json[:data]
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
      
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
     
      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
      
      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)

      updated_item = Item.find(item1.id)

      expect(updated_item.name).to_not eq('old name')
      expect(updated_item.name).to eq(update_params[:name])
      expect(updated_item.description).to_not eq('old description')
      expect(updated_item.description).to eq(update_params[:description])
      expect(updated_item.unit_price).to_not eq('old unit_price')
      expect(updated_item.unit_price).to eq(update_params[:unit_price])
      expect(updated_item.merchant_id).to_not eq(m1.id)
      expect(updated_item.merchant_id).to eq(update_params[:merchant_id])
    end

    it 'returns an error if item update invalid' do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      update_params = {
        name: '',
        description: '',
        unit_price: '',
        merchant_id: ''
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate(item: update_params)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.status).to eq(422)
      
      error_json = JSON.parse(response.body, symbolize_names:true)
      expect(error_json[:errors].first[:detail]).to eq("Validation failed: Merchant must exist, Name can't be blank, Description can't be blank, Unit price can't be blank, Unit price is not a number")

      update_params = {
        name: 'new_name',
        description: 'new_description',
        unit_price: -1,
        merchant_id: merchant1.id
      }

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate(item: update_params)
      error_json = JSON.parse(response.body, symbolize_names:true)
      expect(error_json[:errors].first[:detail]).to eq("Validation failed: Unit price must be greater than or equal to 0")
    end
  end
end