gem 'silent-postgres', :group => :development

db_username = ask_wizard("What's your database username? (Leave blank to use the default)")
unless db_username.blank?
  gsub_file 'config/database.yml', "username: #{app_name}", "username: #{db_username}"
end