class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def passthru
    render :file => File.join(Rails.root, "public", "404.html"), :status => 404, :layout => false
  end
  
protected
  
  def authenticate_with(provider)
    session[:omniauth] = nil
    auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect authentication.user, :event => :authentication
    
    elsif user_signed_in?
      current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to user_authentications_path(current_user)
    
    else
      user_hash = auth['extra']['user_hash'] rescue {}      
      user = User.new(:email => user_hash['email'], :name => auth['user_info']['name'])
      user.apply_omniauth(auth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect user, :event => :authentication
      else
        session[:omniauth] = auth.except('extra')
        redirect_to new_user_registration_path
      end
    end
    
  end
end