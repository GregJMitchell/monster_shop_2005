# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3)
      @cart = Cart.new({
                         @ogre.id.to_s => 1,
                         @giant.id.to_s => 2
                       })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
                                     @ogre.id.to_s => 1,
                                     @giant.id.to_s => 2
                                   })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
                                     @ogre.id.to_s => 1,
                                     @giant.id.to_s => 2,
                                     @hippo.id.to_s => 1
                                   })
    end

    it '.subtract_item()' do
      @cart.subtract_item(@giant.id.to_s)
      expect(@cart.contents).to eq({
                                     @ogre.id.to_s => 1,
                                     @giant.id.to_s => 1
                                   })
    end

    it '.total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq({ @ogre => 1, @giant => 2 })
    end

    it '.total' do
      expect(@cart.total).to eq(120)
    end

    it '.subtotal()' do
      expect(@cart.subtotal(@ogre)).to eq(20)
      expect(@cart.subtotal(@giant)).to eq(100)
    end

    it 'find_discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      item_2 = create(:item)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
      user = create(:user, email: 'user@gmail.com', password: 'password')
      cart = Cart.new({
                        item.id.to_s => 2,
                        item_2.id.to_s => 1
                      })

      expect(cart.find_discount(item)).to eq(discount)
    end

    it 'apply_discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      item_2 = create(:item)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
      user = create(:user, email: 'user@gmail.com', password: 'password')

      cart = Cart.new({
                        item.id.to_s => 2,
                        item_2.id.to_s => 1
                      })
      discount_total = 2 * (item.price * (discount.discount / 100))
      item_subtotal = 2 * item.price - discount_total

      expect(cart.apply_discount(item, discount)).to eq(item_subtotal)
    end

    it 'subtotal with bulk_discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      item_2 = create(:item)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
      user = create(:user, email: 'user@gmail.com', password: 'password')

      cart = Cart.new({
                        item.id.to_s => 2,
                        item_2.id.to_s => 1
                      })

      discount_total = 2 * (item.price * (discount.discount / 100))
      item_subtotal = 2 * item.price - discount_total

      expect(cart.subtotal(item)).to eq(item_subtotal)
    end
  end
end
