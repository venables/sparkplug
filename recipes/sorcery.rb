gem 'sorcery', "~> 0.6.1"

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
  generate "sorcery_migration core reset_password remember_me brute_force_protection activity_logging external"
  gsub_file "config/initializers/sorcery.rb", "Rails.application.config.sorcery.submodules = []", "Rails.application.config.sorcery.submodules = [:remember_me, :reset_password, :brute_force_protection, :activity_logging, :external]"
  copy_template "app/models/user.rb", :force => true
  
  # Users
  generate "controller Users"
  copy_template "app/controllers/users_controller.rb", :force => true
  %w( new edit show ).each { |v| copy_template "app/views/users/#{v}.html.erb" }
  
  # Sessions
  generate "controller Sessions"
  copy_template "app/controllers/sessions_controller.rb", :force => true
  copy_template "app/views/sessions/new.html.erb", :force => true
  
  # Password Resets
  generate "controller PasswordResets"
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

  
end