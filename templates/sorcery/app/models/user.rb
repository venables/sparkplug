class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation
  
  authenticates_with_sorcery!
  
  validates :username,  :presence => true, :uniqueness => true
  validates :email,     :presence => true, :uniqueness => true, :email => true
  validates :password,  :presence => true, :length => { :minimum => 6 }, :confirmation => { :message => "should match confirmation" }, :on => :create
end
