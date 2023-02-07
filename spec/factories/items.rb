FactoryBot.define do
  factory :item do
    name { Faker::Games::ElderScrolls.weapon }
    description { "Good for killing #{Faker::Games::ElderScrolls.creature}" }
    unit_price { 0.1..50.0 }
    merchant_id { nil }
  end
end
