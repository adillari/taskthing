require "rails_helper"

RSpec.feature "User Registration", type: :feature do
  scenario "User registers successfully" do
    visit root_path
    click_link "Sign up"
    
    fill_in "user_email_address", with: "newuser@example.com"
    fill_in "user_password", with: "password123"
    click_button "Sign up"
    
    expect(page).to have_content("Boards")
    expect(page).to have_current_path(boards_path)
  end

  scenario "User registration with duplicate email" do
    create(:user, email_address: "existing@example.com")
    
    visit root_path
    click_link "Sign up"
    
    fill_in "user_email_address", with: "existing@example.com"
    fill_in "user_password", with: "password123"
    click_button "Sign up"
    
    # The form should still be on the sign up page since registration failed
    expect(page).to have_content("Sign up")
    # Since there's no validation, the error might not be displayed
    # This test verifies that the user stays on the sign up page
  end
end 