# for Rails 3.1+, use optimistic versioning for gems
gem 'cucumber-rails',   '>= 1.0.3', :group => :test
gem 'capybara',         '>= 1.0.0', :group => :test
gem 'database_cleaner', '>= 0.6.7', :group => :test
gem 'launchy',          '>= 0.4.0', :group => :test


after_bundler do
  say_wizard "Cucumber recipe running 'after bundler'"
  generate "cucumber:install --capybara --rspec"

  say_wizard "Copying Cucumber scenarios from the rails3-devise-rspec-cucumber examples"
  # copy all the Cucumber scenario files from the rails3-devise-rspec-cucumber example app
  
  
  %w(user_authenticates user_registers user_signs_out).each do |f|
    copy_template "features/scenarios/authentication/#{f}.feature"
  end
  
  %w(edit show).each do |f|
    copy_template "features/scenarios/users/#{f}.feature"
  end
  

  # Step Definitions
  %w(authentication_steps global_steps user_steps).each do |f|
    copy_template "features/step_definitions/#{f}.rb"
  end
  
  # Paths
  remove_file 'features/support/paths.rb'
  copy_template "features/support/paths.rb"
  
  inject_into_file "lib/tasks/cucumber.rake", :after => /t.profile = 'default'/ do
    "\n      t.cucumber_opts = '--format progress'"
  end
end