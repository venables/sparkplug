class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  
  before_filter :set_pagination_variables
  def set_pagination_variables
    @page = [params[:page].to_i, 1].max
  end
  
end
