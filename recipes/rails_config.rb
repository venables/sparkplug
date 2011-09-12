gem "rails_config"

after_bundler do
  say_wizard "Generating RailsConfig files"
  generate "rails_config:install"
  
  copy_template "config/settings.yml", :force => true
  gsub_file "config/settings.yml", /AppName/, @app_name
end