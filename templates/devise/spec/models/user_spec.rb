require 'spec_helper'

describe User do
  
  describe "when being created" do
    before do
      @user = Factory.build(:user)
      @existing_user = Factory.create(:user)
    end
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:email) }
    it { should ensure_length_of(:password).is_at_least(6) }
    it { should_not allow_mass_assignment_of(:encrypted_password) }
    
    %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |email|
      it { should allow_value(email).for(:email) }
    end
    
    %w[user@foo,com user_at_foo.org example.user@foo.].each do |email|
      it { should_not allow_value(email).for(:email) }
    end
  end
  
end