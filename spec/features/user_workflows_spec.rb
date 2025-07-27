require "rails_helper"

RSpec.feature "User Workflows", type: :feature do
  scenario "User registration and login workflow" do
    # Step 1: User registration
    visit root_path
    click_link "Sign up"
    
    fill_in "user_email_address", with: "workflow@example.com"
    fill_in "user_password", with: "password123"
    click_button "Sign up"
    
    expect(page).to have_content("Boards")
    expect(page).to have_current_path(boards_path)
    
    # Step 2: Create a new board
    click_link "+ New Board"
    fill_in "board_title", with: "My Workflow Board"
    click_button "Create!"
    
    expect(page).to have_content("My Workflow Board")
    expect(page).to have_current_path(boards_path)
  end

  scenario "User login workflow" do
    user = create(:user, email_address: "login@example.com", password: "password123")
    
    visit root_path
    click_link "Login"
    
    fill_in "email_address", with: "login@example.com"
    fill_in "password", with: "password123"
    click_button "Login"
    
    expect(page).to have_content("Boards")
    expect(page).to have_current_path(boards_path)
  end

  scenario "User login with invalid credentials" do
    user = create(:user, email_address: "invalid@example.com", password: "password123")
    
    visit root_path
    click_link "Login"
    
    fill_in "email_address", with: "invalid@example.com"
    fill_in "password", with: "wrongpassword"
    click_button "Login"
    
    expect(page).to have_content("Login")
    expect(page).to have_content("Try another email address or password")
  end

  scenario "User registration with duplicate email" do
    create(:user, email_address: "duplicate@example.com")
    
    visit root_path
    click_link "Sign up"
    
    fill_in "user_email_address", with: "duplicate@example.com"
    fill_in "user_password", with: "password123"
    click_button "Sign up"
    
    expect(page).to have_content("Sign up")
    expect(page).to have_content("has already been taken")
  end
end 