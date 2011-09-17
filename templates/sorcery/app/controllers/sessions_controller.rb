class SessionsController < ApplicationController
  def create
    unless login(params[:username], params[:password], params[:remember_me])
      flash.now.alert = "Username or password was invalid"
      render :action => 'new' and return
    end
    
    redirect_back_or_to root_url, :notice => "Logged in!"
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
end
