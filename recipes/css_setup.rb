after_bundler do
  say_wizard "CssSetup recipe running 'after bundler'" 
  append_file 'app/assets/stylesheets/application.css', contents_of_file(template_path("application.css"))
end