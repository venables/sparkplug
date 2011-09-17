class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def reset_password_email(user)
    @url = reset_password_url(:id => user.reset_password_token, :host => "test.com")
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Reset your password")
  end
end
