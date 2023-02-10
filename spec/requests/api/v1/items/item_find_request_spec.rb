require 'rails_helper'

RSpec.describe 'Item Find API' do
  describe 'find a single item which matches a search term' do
    describe 'name search' do
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
  
      it 'if more than one match, will return the first in alphabetical order' do
        item1 = create(:item, name: 'Turing')
        item2 = create(:item, name: 'Ring World')
  
        get "/api/v1/items/find?name=ring"
  
        expect(response).to have_http_status(:ok)
  
        item_json = JSON.parse(response.body, symbolize_names:true)
  
        item_data = item_json[:data]
        attributes = item_data[:attributes]
        
        expect(attributes[:name]).to eq(item2.name)
      end
  
      it 'if no query params raises error' do
        get "/api/v1/items/find?name="
  
        expect(response).to have_http_status(:bad_request)
  
        error_json = JSON.parse(response.body, symbolize_names:true)
        expect(error_json[:errors].first[:detail]).to eq("Record invalid")
        
        get "/api/v1/items/find"
  
        expect(response).to have_http_status(:bad_request)
  
        error_json = JSON.parse(response.body, symbolize_names:true)
        expect(error_json[:errors].first[:detail]).to eq("Record invalid")
      end

      it 'if no matches returns empty data response' do
        get "/api/v1/items/find?name=ring"
        expect(response).to have_http_status(:ok)
        item_json = JSON.parse(response.body, symbolize_names:true)
        item_data = item_json[:data]

        expect(item_data).to be_a(Hash)
      end
    end

    describe 'unit_price search' do
      describe 'happy paths' do
        it 'will return first item that is greater than min value alphabetically' do
          item1 = create(:item, name: 'Carrot', unit_price: 4.99)
          item2 = create(:item, name: 'Banana', unit_price: 4.99)
          item3 = create(:item, name: 'Apple', unit_price: 2.50)
  
          get "/api/v1/items/find?min_price=#{item3.unit_price+1}"
  
          # require 'pry'; binding.pry
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
          expect(attributes[:name]).to eq(item2.name)
          
          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)
         
          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)
          
          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
  
        it 'will return first item that is less than max value alphabetically' do
          item1 = create(:item, name: 'Carrot', unit_price: 4.99)
          item2 = create(:item, name: 'Banana', unit_price: 4.99)
          item3 = create(:item, name: 'Apple', unit_price: 2.50)
  
          get "/api/v1/items/find?max_price=#{item2.unit_price}"
  
          # require 'pry'; binding.pry
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
          expect(attributes[:name]).to eq(item3.name)
          
          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)
         
          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)
          
          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
  
        it 'will return first item that is between the max and min value alphabetically' do
          item1 = create(:item, name: 'Carrot', unit_price: 7.99)
          item2 = create(:item, name: 'Banana', unit_price: 4.99)
          item3 = create(:item, name: 'Apple', unit_price: 2.50)
  
          get "/api/v1/items/find?max_price=#{item1.unit_price}&min_price=#{item3.unit_price}"
  
          # require 'pry'; binding.pry
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
          expect(attributes[:name]).to eq(item3.name)
          
          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)
         
          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)
          
          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end

        it 'no match will return empty data' do
          get "/api/v1/items/find?min_price=0"

          expect(response).to have_http_status(:ok)

          item_json = JSON.parse(response.body, symbolize_names:true)
          item_data = item_json[:data]
          expect(item_data).to be_a(Hash)

          get "/api/v1/items/find?max_price=100"

          expect(response).to have_http_status(:ok)

          item_json = JSON.parse(response.body, symbolize_names:true)
          item_data = item_json[:data]
          expect(item_data).to be_a(Hash)

          get "/api/v1/items/find?max_price=100&min_price=0"

          expect(response).to have_http_status(:ok)

          item_json = JSON.parse(response.body, symbolize_names:true)
          item_data = item_json[:data]
          expect(item_data).to be_a(Hash)

          item1 = create(:item, name: 'Carrot', unit_price: 7.99)
          item2 = create(:item, name: 'Banana', unit_price: 4.99)

          get "/api/v1/items/find?max_price=2"

          expect(response).to have_http_status(:ok)

          item_json = JSON.parse(response.body, symbolize_names:true)
          item_data = item_json[:data]
          expect(item_data).to be_a(Hash)

          get "/api/v1/items/find?min_price=50"

          expect(response).to have_http_status(:ok)

          item_json = JSON.parse(response.body, symbolize_names:true)
          item_data = item_json[:data]
          expect(item_data).to be_a(Hash)
        end
      end

      describe 'sad paths' do
        it 'returns bad_request if min or max is negative' do
          get "/api/v1/items/find?min_price=-1"

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price=-1"

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price=-1&min_price=-1"

          expect(response).to have_http_status(:bad_request)
        end

        it 'cannot send name and min or max' do
          item = create(:item, name: 'foo', unit_price: 10)
          get "/api/v1/items/find?min_price=10&name=foo"

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price=10&name=foo"

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price=10&name=foo&min_price=10"

          expect(response).to have_http_status(:bad_request)
        end

        it 'min price cannot be greater than max price' do
          get "/api/v1/items/find?min_price=11&max_price=10"

          expect(response).to have_http_status(:bad_request)
        end
      end

      describe 'edge cases' do
        it 'returns error if price is not set' do
          get "/api/v1/items/find?min_price="

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price="

          expect(response).to have_http_status(:bad_request)

          get "/api/v1/items/find?max_price=&min_price="

          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end