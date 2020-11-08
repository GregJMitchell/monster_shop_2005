FactoryBot.define do
  factory :bulk_discount do
    merchant
    item
    discount { Faker::Number.within(range: 1..100) }
    quantity { Faker::Number.within(range: 1..item.inventory)}
  end
end