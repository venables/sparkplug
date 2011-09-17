class PasswordResetsController < ApplicationController
  before_filter :find_user, :only => [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! unless @user.blank?
    redirect_to root_url, :notice => "If you have an account, we emailed instructions to you."
  end

  def edit
  end
  
  def update
    unless params[:password_confirmation] == params[:password]
      flash.now.alert = "The password and confirmation do not match. Please try again"
      render :action => 'edit' and return
    end
      
    unless @user.change_password!(params[:password])
      flash.now.alert = "There was an error setting your password. Please try again."
      render :action => 'edit' and return
    end
    
    redirect_to login_path, :notice => "Your password has been updated."
  end
  
protected
  
  def find_user
    @user = User.load_from_reset_password_token(params[:id])
    redirect_to root_url, :alert => "That's not a valid token" if @user.blank?
  end
  
end
