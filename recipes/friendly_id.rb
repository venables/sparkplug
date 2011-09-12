gem "friendly_id", ">= 4.0.0.beta11"

after_bundler do
  say_wizard "Generating FriendlyId files"

  generate 'migration AddSlugToUsers slug:string'
  # TODO: add index to this migration 
  
  inject_into_file 'app/models/user.rb', :after => 'ActiveRecord::Base\n' do
    "  extend FriendlyId\n  friendly_id :username, :use => :slugged"
  end
end
