class ItemSerializer
  def self.new(object)
    if object.nil?
      { data: {
        id: nil,
        type: nil,
        attributes: {
          name: nil,
          description: nil,
          unit_price: nil,
          merchant_id: nil
        }
      } }
    elsif object.class == Item
      { 
        data: 
          {
            id: object.id.to_s,
            type: 'item',
            attributes: 
              {
                name: object.name,
                description: object.description,
                unit_price: object.unit_price,
                merchant_id: object.merchant.id
              }
          } 
      }
    else
      { 
        data: object.map do |item|
          {
            id: item.id.to_s,
            type: 'item',
            attributes: {
              name: item.name,
              description: item.description,
              unit_price: item.unit_price,
              merchant_id: item.merchant.id
              }
          } 
        end
      }
    end
  end
end