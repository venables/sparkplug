class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def can_be_destroyed?
    !(user.email.blank? && user.authentications.count < 2)
  end
end
