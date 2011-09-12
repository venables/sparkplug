after_bundler do
  say_wizard "HomePage recipe running 'after bundler'"
  
  # remove the default home page, default image
  remove_file 'public/index.html'
  remove_file 'app/assets/images/rails.png'
  
  # create a home controller and view
  generate(:controller, "home index")
  
  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
  
  # Build the homepage
  remove_file 'app/views/home/index.html.erb'
  copy_template 'app/views/home/index.html.erb'
end