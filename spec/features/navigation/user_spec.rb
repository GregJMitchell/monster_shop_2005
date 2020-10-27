# frozen_string_literal: true

require 'rails_helper'

describe 'As a default user' do
  describe 'I see the same links as a visitor' do
    it 'Plus the following links a link to my profile page (/profile),a link to log out (/logout)' do
      jake = User.create!(name: 'JakeBob',
                          address: '124 Main St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: '80202',
                          email: 'JBob1234@hotmail.com',
                          password: 'heftybags',
                          password_confirmation: 'heftybags')

      visit '/login'
      fill_in :email, with: jake.email
      fill_in :password, with: jake.password

      
      expect(page).to have_link('Home')
      expect(page).to have_link('All Items')
      expect(page).to have_link('All Merchants')
      expect(page).to have_link('Cart')
      expect(page).to have_link('Register')
      expect(page).to have_content('0')
      click_on "Login"
      expect(page).to have_link('My Profile')
      expect(page).to have_link('Log Out')
      expect(page).not_to have_link('Log In')
      expect(page).not_to have_link('Register')
      expect(page).to have_content("Logged in as #{jake.name}")
    end
  end
end
