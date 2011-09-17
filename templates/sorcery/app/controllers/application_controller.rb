class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :logged_in?
  
protected

  def not_authenticated
    redirect_to login_url, :alert => "Please log in."
  end
  
end
