after_bundler do
  say_wizard "HomePage recipe running 'after bundler'"
    
  # create a home controller and view
  generate(:controller, "home index")
  
  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
  
  # Build the homepage
  remove_file 'app/views/home/index.html.erb'
  copy_template 'app/views/home/index.html.erb'
end