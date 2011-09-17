gem "friendly_id", ">= 4.0.0.beta11"

after_bundler do
  say_wizard "Generating FriendlyId files"

  generate 'migration AddSlugToUsers slug:string'
  # TODO: add index to this migration 
  
  inject_into_file 'app/models/user.rb', :after => /ActiveRecord::Base/ do
    "\n  extend FriendlyId\n"
  end
  
  inject_into_file "app/models/user.rb", :after => /authenticates_with_sorcery!/ do
    "\n  friendly_id :username, :use => :slugged"
  end
end
