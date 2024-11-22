class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    redirect_to(boards_path) if resume_session
  end
end
