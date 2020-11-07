# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit my merchant dashboard' do
    it 'I see link to create a new bulk discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      expect(page).to have_link('New Bulk Discount')
      expect(page).to have_content('Current Bulk Discounts')
    end

    it "When I click on the 'new bulk discount' link, I am taken to a form to create a new bulk discount" do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      click_on 'New Bulk Discount'

      expect(current_path).to eq('/merchant/bulk_discounts/new')

      !find_field(:bulk_discount_item_name)
      !find_field(:bulk_discount_discount)
      !find_field(:bulk_discount_quantity)
    end

    it 'When I fill out the form and click submit, I am taken back to the merchant dashboard where I see the new discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant/bulk_discounts/new'

      fill_in :bulk_discount_item_name,	with: "#{item.name}" 
      fill_in :bulk_discount_discount,	with: "20" 
      fill_in :bulk_discount_quantity,	with: "10" 

      click_on "Create Bulk discount"

      bulk_discount = BulkDiscount.last
      within "#discount-#{bulk_discount.id}" do
        expect(page).to have_content(bulk_discount.item.name)
        expect(page).to have_content(bulk_discount.discount)
        expect(page).to have_content(bulk_discount.quantity)
      end
    end
  end
end
