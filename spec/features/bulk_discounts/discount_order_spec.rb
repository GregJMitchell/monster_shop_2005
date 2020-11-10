# frozen_string_literal: true

require 'rails_helper'

describe 'As a regular user' do
  describe 'When I visit my cart after adding an item that has a bulk discount to it' do
    describe 'And I increase the quantity to the discounts required quantity' do
      it 'When I place an order, the price on the order show page is the new discounted price' do
        merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
        item = create(:item, merchant: merchant_user.merchant)
        item_2 = create(:item)
        discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
        user = create(:user, email: 'user@gmail.com', password: 'password')

        visit '/login'

        fill_in :email, with: user.email
        fill_in :password, with: 'password'
        click_button 'Login'

        visit "/items/#{item.id}"

        click_on 'Add To Cart'

        visit "/items/#{item_2.id}"

        click_on 'Add To Cart'

        visit '/cart'

        within "#cart-item-#{item.id}" do
          click_on '+'
        end

        click_on 'Checkout'

        fill_in :name, with: user.name
        fill_in :address, with: user.address
        fill_in :city, with: user.city
        fill_in :state, with: user.state
        fill_in :zip, with: user.zip

        click_button 'Create Order'

        new_order = Order.last

        visit "/profile/orders/#{new_order.id}"

        discount_total = 2 * (item.price * (discount.discount / 100))
        item_subtotal = 2 * item.price - discount_total

        expect(page).to have_content(number_to_currency(item_subtotal))
        expect(page).to have_content(number_to_currency(item_subtotal + item_2.price))
      end

      it "If an item in the order is not discounted at all, I do not see any text in the discount column for that item" do
        merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
        item = create(:item, merchant: merchant_user.merchant)
        item_2 = create(:item)
        discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
        user = create(:user, email: 'user@gmail.com', password: 'password')

        visit '/login'

        fill_in :email, with: user.email
        fill_in :password, with: 'password'
        click_button 'Login'

        visit "/items/#{item.id}"

        click_on 'Add To Cart'

        visit "/items/#{item_2.id}"

        click_on 'Add To Cart'

        visit '/cart'

        within "#cart-item-#{item.id}" do
          click_on '+'
        end
        
        click_on 'Checkout'

        fill_in :name, with: user.name
        fill_in :address, with: user.address
        fill_in :city, with: user.city
        fill_in :state, with: user.state
        fill_in :zip, with: user.zip

        click_button 'Create Order'

        new_order = Order.last

        visit "/profile/orders/#{new_order.id}"
        
        within "#item-#{new_order.item_orders.last.item_id}" do
          expect(page).not_to have_content("off on or more")
        end
      end

      it "And the grandtotal has the discount applied to it as well" do
        merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
        item = create(:item, merchant: merchant_user.merchant)
        item_2 = create(:item)
        discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id, quantity: 2, discount: 10)
        user = create(:user, email: 'user@gmail.com', password: 'password')

        visit '/login'

        fill_in :email, with: user.email
        fill_in :password, with: 'password'
        click_button 'Login'

        visit "/items/#{item.id}"

        click_on 'Add To Cart'

        visit "/items/#{item_2.id}"

        click_on 'Add To Cart'

        visit '/cart'

        within "#cart-item-#{item.id}" do
          click_on '+'
        end
        
        click_on 'Checkout'

        fill_in :name, with: user.name
        fill_in :address, with: user.address
        fill_in :city, with: user.city
        fill_in :state, with: user.state
        fill_in :zip, with: user.zip

        click_button 'Create Order'

        new_order = Order.last

        visit "/profile/orders/#{new_order.id}"

        discount_total = 2 * (item.price * (discount.discount / 100))
        item_subtotal = 2 * item.price - discount_total

        within "#grandtotal" do
          expect(page).to have_content(number_to_currency(item_subtotal + item_2.price))
        end
      end
      
    end
  end
end
