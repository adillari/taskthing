class ApplicationController < ActionController::Base
  include Authentication

  private

  def render_unprocessable
    render(file: Rails.public_path.join("422.html"), status: :unprocessable_entity)
  end
end
