class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def data_hash
    return {} if data.blank?
    YAML::load(data)
  end
  
  def user_info
    data_hash['user_info'] || {}
  end
  
  def nickname
    user_info['nickname']
  end
  
end
