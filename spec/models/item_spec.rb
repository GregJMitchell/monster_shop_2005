require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
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

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2, merchant_id: @bike_shop.id)
      expect(@chain.no_orders?).to eq(false)
    end

    it '#order_quantity' do 
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
      order_2 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_4 = order_2.item_orders.create!(item: chain, price: chain.price, quantity: 6, status: 'Pending', merchant_id: bike_shop.id)
      order_item_5 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 10, status: 'Pending', merchant_id: bike_shop.id)

      expect(tire.order_quantity(order_1.id)).to eq(2)
    end
    
    it '#status' do
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
      order_2 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_4 = order_2.item_orders.create!(item: chain, price: chain.price, quantity: 6, status: 'Pending', merchant_id: bike_shop.id)
      order_item_5 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 10, status: 'Pending', merchant_id: bike_shop.id)

      expect(chain.status(order_1.id)).to eq("Pending")
    end

    it "#status" do
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
      order_2 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_4 = order_2.item_orders.create!(item: chain, price: chain.price, quantity: 6, status: 'Pending', merchant_id: bike_shop.id)
      order_item_5 =  order_2.item_orders.create!(item: tire, price: tire.price, quantity: 10, status: 'Pending', merchant_id: bike_shop.id)

      expect(chain.order_item(order_1.id)).to eq(order_item_1.id)
    end

    describe "class methods" do
      before(:each) do
        require 'pry'; binding.pry
        @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
        @string = @bike_shop.items.create(name: "String", description: "It'll probably break!", price: 5, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", active?: false, inventory: 5)
        order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)
        order.item_orders.create(item: @chain, price: @chain.price, quantity: 2, merchant_id: @bike_shop.id)
        order.item_orders.create(item: @string, price: @string.price, quantity: 1, merchant_id: @bike_shop.id)
      end
      it 'find_enabled_items' do
        expect(Item.find_enabled_items.first.name).to eq(@chain.name)
      end

      it 'top_five' do
        expect(Item.top_five.first.name).to eq(@chain.name)
      end

      it 'bottom_five' do
        expect(Item.bottom_five.first.name).to eq(@string.name)
      end
    end
  end
end
