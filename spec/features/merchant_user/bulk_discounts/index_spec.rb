# frozen_string_literal: true

require 'rails_helper'

describe 'As a merchant user' do
  describe 'When I visit my merchant dashboard' do
    it 'I see link to create a new bulk discount' do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      expect(page).to have_link('New Bulk Discount')
      expect(page).to have_content("Current Bulk Discounts")
    end

    it "When I click on the 'new bulk discount' link, I am taken to a form to create a new bulk discount" do
      merchant_user = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      click_on "New Bulk Discount"

      expect(current_path).to eq('/merchant/bulk-discount/new')
      !find_field()
    end
    
  end
end
