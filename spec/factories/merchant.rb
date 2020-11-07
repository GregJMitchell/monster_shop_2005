FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip  { Faker::Address.zip }

    factory :disabled_merchant do
      enabled? { false }
    end
  end
end