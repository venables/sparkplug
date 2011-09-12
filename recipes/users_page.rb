after_bundler do
  say_wizard "UsersPage recipe running 'after bundler'"

  # Users controller
  generate(:controller, "users index show")
  copy_template 'app/controllers/users_controller.rb', :force => true

  # Routes
  gsub_file 'config/routes.rb', /get \"users\/show\"/, '#get \"users\/show\"'
  inject_into_file "config/routes.rb", :after => "devise_for :users\n" do
    contents_of_file template_path("config/routes.rb")
  end

  # Views
  copy_template "app/views/users/show.html.erb", :force => true
  copy_template "app/views/users/index.html.erb", :force => true
  copy_template "app/views/users/_user.html.erb"
end
