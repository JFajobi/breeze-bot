class AuthenticationsController < ApplicationController

  before_filter :redirect_unless_logged_in

  # Ensures that user is logged in before viewing the page
  def redirect_unless_logged_in
    unless current_member
      session[:redirect] = request.original_url
      flash.alert = "You must be logged in to view page"
      redirect_to root_path and return false
    end
  end

end