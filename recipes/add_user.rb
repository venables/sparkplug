# TODO: Merge into devise?

after_bundler do
  
  say_wizard "AddUser recipe running 'after bundler'"

  # Generate models and routes for a User
  generate 'devise user'

  # Add a 'name' attribute to the User model
  # for ActiveRecord
  # Devise created a Users database, we'll modify it
  generate 'migration AddUsernameToUsers username:string'
  gsub_file 'app/models/user.rb', /attr_accessible :email/, 'attr_accessible :username, :email'
  inject_into_file 'app/models/user.rb', :before => 'attr_accessible' do
    contents_of_file template_path("validations.rb")
  end

  generate 'devise:views'
    
  # Modify Devise views to add 'username'
  inject_into_file "app/views/devise/registrations/new.html.erb", :after => "<%= devise_error_messages! %>\n" do
    contents_of_file template_path("new.html.erb")
  end
  inject_into_file "app/views/devise/registrations/edit.html.erb", :after => "<%= devise_error_messages! %>\n" do
    contents_of_file template_path("edit.html.erb")
  end
end
