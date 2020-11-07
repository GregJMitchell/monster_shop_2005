# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit my merchant dashboard' do
    describe 'I see link that is the id of a a bulk discount' do
      it 'When I click on that link, I am taken to that discounts show page' do
        merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
        item = create(:item, merchant: merchant_user.merchant)
        discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

        visit '/merchant/bulk_discounts'

        click_on "Bulk Discount ##{discount.id}"

        expect(current_path).to eq("/merchant/bulk_discounts/#{discount.id}")
      end

      it "On the show page I see the discounts item name, discount percent, and quantity required for the discount" do
        merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
        item = create(:item, merchant: merchant_user.merchant)
        discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

        visit "/merchant/bulk_discounts/#{discount.id}"

        expect(page).to have_content(discount.item.name)
        expect(page).to have_content(discount.discount)
        expect(page).to have_content(discount.quantity)
      end
    end
  end
end
