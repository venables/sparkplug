
has_many :authentications, :dependent => :destroy

def password_required?  
  (authentications.blank? || !password.blank?) && super  
end

def apply_omniauth(omniauth)  
  authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :data => omniauth)  
end