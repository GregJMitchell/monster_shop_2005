FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip  { Faker::Address.zip }
    email  { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role {0}

    factory :merchant_employee do
      role {1}
      merchant
    end

    factory :admin do
      role {2}
    end
  end
end