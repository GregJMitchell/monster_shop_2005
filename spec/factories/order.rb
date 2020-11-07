FactoryBot.define do
  factory :order do
    user
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip  { Faker::Address.zip }
    factory :packaged_order do
      status { :packaged }
    end
    factory :shipped_order do
      status { :shipped }
    end
    factory :cancelled_order do
      status { :cancelled }
    end
  end
end