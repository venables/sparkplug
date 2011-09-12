class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
    
  def index
    @authentications = current_user.authentications.all
  end  
      
  def destroy
    @authentication = current_user.authentications.find(params[:id])  
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to user_authentications_path(current_user)
  end
  
end
