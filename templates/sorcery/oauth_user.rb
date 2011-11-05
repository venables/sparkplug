class User < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :oauth
  
  authenticates_with_sorcery!
  friendly_id :username, :use => :slugged
  
  has_many :authentications, :dependent => :destroy
  
  validates :username,  :presence => true, 
                        :uniqueness => true
  validates :email,     :presence => true, 
                        :uniqueness => { :unless => lambda { |u| u.email.blank? }}, 
                        :email => true, 
                        :unless => lambda { |u| u.using_oauth? }
  validates :password,  :presence => true, 
                        :length => { :minimum => 6 }, 
                        :confirmation => { :message => "should match confirmation" }, 
                        :on => :create, 
                        :unless => lambda { |u| u.using_oauth? }

  def using_oauth?
    @oauth || self.authentications.any?
  end

  def self.new_from_oauth(oauth)
    user = self.new(:username => oauth[:user_info]['screen_name'] || oauth[:user_info]['username'])
    user.oauth = true
    user
  end

end
