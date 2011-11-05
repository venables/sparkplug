gem 'sorcery', "~> 0.6.1"

use_oauth = yes_wizard?("Do you want to allow users to authenticate with twitter or facebook?")
if use_oauth
  use_twitter = yes_wizard?("Do you want to use twitter for oauth?")
  use_facebook = yes_wizard?("Do you want to use facebook for oauth?")
end

after_bundler do
  say_wizard "Sorcery recipe running 'after bundler'"
  
  # Bootstrap sorcery
  run "rake sorcery:bootstrap"
  
  # Copy the application controller
  copy_template "app/controllers/application_controller.rb", :force => true
  
  # Build a mailer
  generate 'mailer UserMailer'
  copy_template "app/mailers/user_mailer.rb", :force => true
  copy_template "app/views/user_mailer/reset_password_email.text.erb", :force => true
  inject_into_file "config/initializers/sorcery.rb", :before => /# user.reset_password_mailer/ do
    "user.reset_password_mailer = UserMailer\n  "
  end
  
  # Build user, setup sorcery
  generate "model User --skip-migration"
  modules = %w( reset_password remember_me brute_force_protection activity_logging )
  modules << "external" if use_oauth
  generate "sorcery_migration core #{modules.join(" ")}" unless @use_mongo
  gsub_file "config/initializers/sorcery.rb", "Rails.application.config.sorcery.submodules = []", "Rails.application.config.sorcery.submodules = [:#{modules.join(", :")}]"
  copy_template "app/models/user.rb", :force => true
  
  if @use_mongo
    gsub_file "app/models/user.rb", / < ActiveRecord::Base/, "\n  include Mongoid::Document\n  include Mongoid::Timestamps"
  end
  
  # Users
  generate "controller Users --helper false"
  copy_template "app/controllers/users_controller.rb", :force => true
  %w( new edit show ).each { |v| copy_template "app/views/users/#{v}.html.erb" }
  
  # Sessions
  generate "controller Sessions --helper false"
  copy_template "app/controllers/sessions_controller.rb", :force => true
  copy_template "app/views/sessions/new.html.erb", :force => true
  
  # Password Resets
  generate "controller PasswordResets --helper false"
  copy_template "app/controllers/password_resets_controller.rb", :force => true
  %w( new edit ).each { |v| copy_template "app/views/password_resets/#{v}.html.erb" }
  
  # Routes
  inject_into_file 'config/routes.rb', :after => /routes.draw do/ do
    "\n  " + contents_of_file(template_path("routes.rb"))
  end
  
  # RSpec tests
  copy_template "spec/models/user_spec.rb", :force => true
  copy_template "spec/factories/user.rb", :force => true
  
  # Cucumber features
  %w(user_authenticates user_registers user_signs_out).each do |f|
    copy_template "features/scenarios/authentication/#{f}.feature", :force => true
  end
  
  %w(edit show).each do |f|
    copy_template "features/scenarios/users/#{f}.feature", :force => true
  end
  
  %w(authentication_steps user_steps).each do |f|
    copy_template "features/step_definitions/#{f}.rb", :force => true
  end

  copy_template "features/support/paths.rb", :force => true

  # OAuth
  if use_oauth
    inject_into_file "config/initializers/sorcery.rb", :before => /# user.authentications_class/ do
      "user.authentications_class = Authentication "
    end
    
    generate "controller Authentications --helper false"
    copy_template "app/controllers/authentications_controller.rb", :force => true
    copy_template "app/views/authentications/_authentication.html.erb"
    copy_template "app/views/authentications/index.html.erb"
    
    generate "model Authentication --skip-migration"
    copy_template "app/models/authentication.rb", :force => true
    if @use_mongo
      gsub_file "app/models/authentication.rb", / < ActiveRecord::Base/, "\n  include Mongoid::Document\n  include Mongoid::Timestamps"
    end
  
  
    # Update the user model
    remove_file("app/models/user.rb")
    copy_file template_path("oauth_user.rb"), "app/models/user.rb"
    if @use_mongo
      gsub_file "app/models/user.rb", / < ActiveRecord::Base/, "\n  include Mongoid::Document\n  include Mongoid::Timestamps"
    end
  
  
    if use_twitter
      inject_into_file "config/initializers/sorcery.rb", :before => /# config.twitter.key/ do
        contents_of_file template_path("twitter.rb")
      end
      
      %w( users/new.html.erb sessions/new.html.erb ).each do |f|
        append_file "app/views/#{f}", '<p>Log in with <%= link_to "twitter", oauth_path("twitter") %>.</p>'
      end
    end
    
    if use_facebook
      inject_into_file "config/initializers/sorcery.rb", :before => /# config.facebook.key/ do
        contents_of_file template_path("facebook.rb")
      end
      
      %w( users/new.html.erb sessions/new.html.erb ).each do |f|
        append_file "app/views/#{f}", '<p>Log in with <%= link_to "facebook", oauth_path("facebook") %>.</p>'
      end
    end
    
    # Routes
    inject_into_file "config/routes.rb", :after => /resources :password_resets/ do
      contents_of_file template_path("oauth_routes.rb")
    end
    providers = []
    providers << "twitter" if use_twitter
    providers << "facebook" if use_facebook
    
    gsub_file "config/routes.rb", /PROVIDERS_HERE/, providers.compact.join("|")
    
    inject_into_file "config/initializers/sorcery.rb", :before => /# config.external_providers/ do
      "config.external_providers = [:#{providers.join(", :")}]\n"
    end
    
  end
  
end