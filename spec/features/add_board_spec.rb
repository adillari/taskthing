require 'rails_helper'

RSpec.feature "Board Management", type: :feature do
  scenario "User adds a new board" do
    visit root_path
    visit boards_path

    # Click the "New Board" button to open the modal
    click_link "New Board"

    # Fill in the board name field
    fill_in "Board Name", with: "My New Board"

    # Submit the form
    click_button "Create Board"

    # Expect to see the new board on the page
    expect(page).to have_content("My New Board")
  end
end
