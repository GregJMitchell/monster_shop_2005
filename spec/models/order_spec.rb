# frozen_string_literal: true

require 'rails_helper'

describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'relationships' do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      @user = User.create(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'JBob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )

      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @pull_toy = @brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant_id: @meg.id)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, merchant_id: @brian.id)
    end
    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#count_items' do
      expect(@order_1.count_items).to eq(2)
    end
    it '#return_items' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'returnitems.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant_id: meg.id)

      order_1.return_items

      expect(Item.find(tire.id).inventory).to eq(14)
    end

    it '#item_qty' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'J1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      merchant_user = bike_shop.users.create!(name: 'JakeBob',
                                              address: '124 Main St',
                                              city: 'Denver',
                                              state: 'Colorado',
                                              zip: '80202',
                                              email: 'Bob1234@hotmail.com',
                                              password: 'heftybags',
                                              password_confirmation: 'heftybags',
                                              role: 1)
      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = print_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_2 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_4 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 2, status: 'Pending', merchant_id: print_shop.id)

      order_2 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_5 = order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_6 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_7 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)

      expect(order_1.item_qty(bike_shop.id)).to eq(6)
    end

    it '#total_value' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'J1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      merchant_user = bike_shop.users.create!(name: 'JakeBob',
                                              address: '124 Main St',
                                              city: 'Denver',
                                              state: 'Colorado',
                                              zip: '80202',
                                              email: 'Bob1234@hotmail.com',
                                              password: 'heftybags',
                                              password_confirmation: 'heftybags',
                                              role: 1)
      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = print_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_2 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_4 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 2, status: 'Pending', merchant_id: print_shop.id)

      order_2 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_5 = order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_6 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_7 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)

      expect(order_1.total_value(bike_shop.id)).to eq(500.0)
    end

    it '#items_by_merchant' do
      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'itemsbymerchant.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      merchant_user = bike_shop.users.create!(name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'Bob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 1
      )
      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = print_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_2 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 2, status: 'Pending', merchant_id: print_shop.id)

      expect(order_1.items_by_merchant(bike_shop.id)).to eq([chain, tire])
    end
    it '#cancel_order' do
      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'itemsbymerchant.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      merchant_user = bike_shop.users.create!(name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'Bob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 1
      )
      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = print_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_2 =  order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 2, status: 'Pending', merchant_id: print_shop.id)

      order_1.cancel_order

      expect(order_1.status).to eq("Cancelled")
      expect(order_1.item_orders.all? { |item_order| item_order.status == "Unfulfilled"}).to eq(true)
    end

    it '#order_status' do
      user = User.create!(name: 'JakeBob',
                          address: '124 Main St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: '80202',
                          email: 'JBob1234@hotmail.comm',
                          password: 'heftybags',
                          password_confirmation: 'heftybags',
                          role: 0)
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = bike_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)
      order_item_2 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 'Fulfilled', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 2, status: 'Pending', merchant_id: bike_shop.id)

      expect(order_1.status).to eq('Pending')
      order_item_3.update!(status: 'Fulfilled')
      order_1.order_status
      expect(order_1.status).to eq('Packaged')
    end
  end
end
