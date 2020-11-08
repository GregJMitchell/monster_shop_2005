# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit a bulk order show page' do
    it 'I see a link to edit the bulk discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}"

      expect(page).to have_link("Edit Discount")
    end

    it "When I click the edit link, I am taken to a form to edit the discount that is filled in" do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}/edit"

      expect(find_field(:bulk_discount_item_name).value).to eq(discount.item.name)
      expect(find_field(:bulk_discount_discount).value).to eq(discount.discount.to_s)
      expect(find_field(:bulk_discount_quantity).value).to eq(discount.quantity.to_s)
    end

    it "When I change the information and click submit, I am taken back to the discount's show page where I see the change info" do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}/edit"

      fill_in :bulk_discount_quantity,	with: "15" 

      click_on "Update Bulk discount"

      expect(current_path).to eq("/merchant/bulk_discounts/#{discount.id}")
      expect(page).to have_content("15")
    end

    it 'If the item name entered is not found in the merchants list' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}/edit"

      fill_in :bulk_discount_item_name,	with: "Item"
      fill_in :bulk_discount_discount,	with: '20'
      fill_in :bulk_discount_quantity,	with: '10'

      click_on 'Update Bulk discount'

      expect(page).to have_content("An item by that name at your merchant does not exist")
    end

    it 'If the information entered is not valid' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}/edit"

      fill_in :bulk_discount_item_name,	with: item.name.to_s
      fill_in :bulk_discount_discount,	with: '1000'
      fill_in :bulk_discount_quantity,	with: '10'

      click_on 'Update Bulk discount'

      expect(page).to have_content("Discount must be less than or equal to 100")
    end
  end
end
