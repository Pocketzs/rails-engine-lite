FactoryBot.define do
  factory :item do
    name { Faker::Games::ElderScrolls.weapon }
    description { "Good for killing #{Faker::Games::ElderScrolls.creature}" }
    unit_price { Faker::Commerce.price }
    merchant_id { nil }
  end
end
