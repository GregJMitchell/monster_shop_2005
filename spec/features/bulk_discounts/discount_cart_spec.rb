require 'rails_helper'

describe 'As a regular user' do
  describe 'When I visit my cart after adding an item that has a bulk discount to it' do
    describe 'And I increase the quantity to the discounts required quantity' do
      it 'The Discount is applied to the items price' do
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

        discount_total = 2 * (item.price * (discount.discount / 100))
        item_subtotal = 2 * item.price - discount_total

        within "#cart-item-#{item.id}" do
          within '#cart-subtotal' do
            expect(page).to have_content(number_to_currency(item_subtotal))
          end
        end

        within '#cart-grandtotal' do
          expect(page).to have_content(number_to_currency(item_subtotal + item_2.price))
        end
      end
    end
  end
end