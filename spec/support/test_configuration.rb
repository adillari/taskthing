RSpec.configure do |config|
  # Use transactions for faster tests
  config.use_transactional_fixtures = true

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Include authentication helpers
  config.include AuthenticationHelper

  # Include shoulda matchers
  config.include Shoulda::Matchers

  # Configure Capybara for feature specs
  config.before(:each, type: :feature) do
    # Use headless Chrome for feature specs
    Capybara.default_driver = :selenium_chrome_headless
    Capybara.javascript_driver = :selenium_chrome_headless
  end

  # Clean up uploaded files after tests
  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join("tmp", "storage"))
  end
end 