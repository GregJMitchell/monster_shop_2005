# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit a bulk order show page' do
    it 'I see a button to delete the discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}"

      expect(page).to have_button('Delete Discount')
    end

    it 'When I click on the delete button, I am redirected to the bulk discount index page, where I no longer see the discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount.id}"

      click_on 'Delete Discount'

      expect(subject).not_to have_content(discount.id.to_s)
    end
  end
end
