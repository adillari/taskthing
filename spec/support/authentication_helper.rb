module AuthenticationHelper
  def sign_in_as(user)
    if defined?(page) && page.respond_to?(:driver)
      # Feature spec - use Capybara
      session = user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1")
      
      # First visit the site to establish the domain
      visit root_path
      
      # Set the session cookie
      page.driver.browser.manage.add_cookie(
        name: "session_token",
        value: session.signed_id,
        path: "/",
        domain: "127.0.0.1"
      )
      
      # Mock Current for the session
      allow(Current).to receive(:session).and_return(session)
    else
      # Request spec - create session and set cookie properly
      session = user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1")
      
      # Set the session cookie in the request
      cookies[:session_token] = session.signed_id
      
      # Mock the find_session_by_cookie method to return our session
      allow_any_instance_of(ApplicationController).to receive(:find_session_by_cookie).and_return(session)
      
      # Set Current.session for model callbacks
      Current.session = session
    end
  end

  def sign_out
    if defined?(page) && page.respond_to?(:driver)
      # Feature spec - clear cookie
      page.driver.browser.manage.delete_cookie("session_token")
      # Clear Current mock
      allow(Current).to receive(:session).and_return(nil)
    else
      # Request spec - clear cookie and remove mocks
      cookies.delete(:session_token)
      allow_any_instance_of(ApplicationController).to receive(:find_session_by_cookie).and_call_original
      # Clear Current.session
      Current.session = nil
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
  config.include AuthenticationHelper, type: :feature
end 