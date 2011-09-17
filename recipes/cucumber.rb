# for Rails 3.1+, use optimistic versioning for gems
gem 'cucumber-rails',   '>= 1.0.3', :group => :test
gem 'capybara',         '>= 1.0.0', :group => :test
gem 'database_cleaner', '>= 0.6.7', :group => :test
gem 'launchy',          '>= 0.4.0', :group => :test


after_bundler do
  say_wizard "Cucumber recipe running 'after bundler'"
  generate "cucumber:install --capybara --rspec"

  copy_template "features/step_definitions/global_steps.rb"

  inject_into_file "lib/tasks/cucumber.rake", :after => /t.profile = 'default'/ do
    "\n      t.cucumber_opts = '--format progress'"
  end
end