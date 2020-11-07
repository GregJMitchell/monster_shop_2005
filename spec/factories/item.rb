FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Number.within(range: 1..10000) }
    image { Faker::LoremPixel.image }
    inventory { Faker::Number.within(range: 1..10000) }

    factory :inactive_item do
      active? { false }
    end
  end
end