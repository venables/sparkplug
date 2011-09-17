# for Rails 3.1+, use optimistic versioning for gems
gem 'rspec-rails',        '>= 2.6.1',   :group => [:development, :test]
gem 'factory_girl_rails', '>= 1.2.0',   :group => :test
gem 'shoulda-matchers',                 :group => :test

after_bundler do
  say_wizard "RSpec recipe running 'after bundler'"
  generate 'rspec:install'

  say_wizard "Removing test folder (not needed for RSpec)"
  run 'rm -rf test/'

  inject_into_file 'config/application.rb', :after => "Rails::Application\n" do
    contents_of_file template_path("application.rb")
  end

  # remove either possible occurrence of "require rails/test_unit/railtie"
  gsub_file 'config/application.rb', /require 'rails\/test_unit\/railtie'/, '# require "rails/test_unit/railtie"'
  gsub_file 'config/application.rb', /require "rails\/test_unit\/railtie"/, '# require "rails/test_unit/railtie"'
end
