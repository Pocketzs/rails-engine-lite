FactoryBot.define do
  factory :item do
    name { Faker::Games::ElderScrolls.weapon }
    description { "Good for killing #{Faker::Games::ElderScrolls.creature}" }
    unit_price { Faker::Number.decimal(l_digits: rand(1..2), r_digits: rand(1..2)) }
    merchant_id { nil }
  end
end
