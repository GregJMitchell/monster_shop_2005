# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit my merchant dashboard' do
    it 'I see link to view all bulk discounts' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      expect(page).to have_link('View Bulk Discounts')
    end

    it 'When I click on the view bulk discounts link, I am taken to the bulk discounts index' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      click_on 'View Bulk Discounts'

      expect(current_path).to eq('/merchant/bulk_discounts')
      
    end

    it "Where I see each discount" do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')
      item = create(:item, merchant: merchant_user.merchant)
      discount = create(:bulk_discount, merchant_id: merchant_user.merchant_id, item_id: item.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts"

      within "#discount-#{discount.id}" do
        expect(page).to have_link(discount.id.to_s)
        expect(page).to have_content(discount.item.name)
      end
    end
  end
end
