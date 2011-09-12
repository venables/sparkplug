gem 'devise', '>= 1.4.2'


after_bundler do
  say_wizard "Devise recipe running 'after bundler'"
  
  # Run the Devise generator
  generate 'devise:install'

  # Prevent logging of password_confirmation
  gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

  gsub_file 'config/initializers/devise.rb', 'config.sign_out_via = :delete', 'config.sign_out_via = :get'
end

after_everything do

  say_wizard "Devise recipe running 'after everything'"

  remove_file 'spec/controllers/home_controller_spec.rb'
  remove_file 'spec/controllers/users_controller_spec.rb'
  remove_file 'spec/models/user_spec.rb'
  
  copy_template 'spec/factories/user.rb'
  copy_template 'spec/controllers/home_controller_spec.rb'
  copy_template 'spec/controllers/users_controller_spec.rb'
  copy_template 'spec/models/user_spec.rb'
  
  remove_file 'spec/views/home/index.html.erb_spec.rb'
  remove_file 'spec/views/users/show.html.erb_spec.rb'
  remove_file 'spec/helpers/home_helper_spec.rb'
  remove_file 'spec/helpers/users_helper_spec.rb'

end