class AuthenticationsController < ApplicationController
  before_filter :require_login, :only => [:index, :destroy]

  def index
    @authentications = current_user.authentications
  end
  
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def new
    login_at(params[:provider])
  end
  
  def create
    # Try to log in with this provider
    if login_from(params[:provider])
      redirect_to root_path, :notice => "Logged in from #{params[:provider].titleize}!" and return
    end
    
    user_hash = Config.send(params[:provider]).get_user_hash
    
    # If we're logged in, add this to the user's authentications
    if logged_in?
      current_user.authentications.create(:provider => params[:provider], :uid => oauth_hash[:uid])
      redirect_to current_user, :notice => "Successfully added your #{params[:provider]} account" and return
    end
    
    # This is a new user
    @user = User.new_from_oauth(user_hash)
    
    User.transaction do
      @user.save!
      authentication = @user.authentications.create!(:provider => params[:provider], :uid => user_hash[:uid])
    end
    
    if @user.new_record? # didn't save
      # session[:oauth] = user_hash # TODO: save oauth data on error?
      render :template => 'users/new', :notice => "There was a problem creating your account." and return
    end
    
    reset_session
    login_user @user
    redirect_to @user, :notice => "Logged in from #{params[:provider]}!"      
  end
  
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    unless @authentication.can_be_destroyed?
      redirect_to :action => 'index', :notice => "Can not unlink this account.  Please set an email address to unlink it." and return
    end
    
    @authentication.destroy
    redirect_to :action => 'index', :notice => "Successfully unlinked the account"
  end
    
end
