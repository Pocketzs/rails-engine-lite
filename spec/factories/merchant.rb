FactoryBot.define do 
  factory :merchant do
    name { Faker::Games::ElderScrolls.name }
  end
end