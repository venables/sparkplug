class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation
  
  authenticates_with_sorcery!
  
  validates :username,  :presence => true, :uniqueness => true
  validates :email,     :presence => true, :uniqueness => true  
  validates_confirmation_of :password, :on => :create, :message => "should match confirmation"
end
