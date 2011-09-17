class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    unless @user.save
      render :action => 'new' and return
    end
    
    redirect_to root_url, :notice => "Signed up!"
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    unless @user.update_attributes(params[:user])
      render :action => 'edit' and return
    end
    
    redirect_to @user, :notice => "Your profile has been updated successfully"
  end
  
end
