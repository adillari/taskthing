require "rails_helper"

RSpec.feature "User Login", type: :feature do
  let(:user) { create(:user, email_address: "test@example.com", password: "password123") }

  scenario "User logs in successfully" do
    user # create the user
    
    visit root_path
    click_link "Login"
    
    fill_in "email_address", with: "test@example.com"
    fill_in "password", with: "password123"
    click_button "Login"
    
    expect(page).to have_content("Boards")
    expect(page).to have_current_path(boards_path)
  end

  scenario "User login with invalid credentials" do
    user # create the user
    
    visit root_path
    click_link "Login"
    
    fill_in "email_address", with: "test@example.com"
    fill_in "password", with: "wrongpassword"
    click_button "Login"
    
    expect(page).to have_content("Login")
    expect(page).to have_content("Try another email address or password")
  end

  scenario "User login with non-existent email" do
    visit root_path
    click_link "Login"
    
    fill_in "email_address", with: "nonexistent@example.com"
    fill_in "password", with: "password123"
    click_button "Login"
    
    expect(page).to have_content("Login")
    expect(page).to have_content("Try another email address or password")
  end

  scenario "User logs out successfully" do
    user # create the user
    
    # First log in
    visit root_path
    click_link "Login"
    fill_in "email_address", with: "test@example.com"
    fill_in "password", with: "password123"
    click_button "Login"
    
    # Then log out
    find("a[href='#{session_path}']").click
    
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Login")
  end
end 