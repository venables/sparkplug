ruby_version = ask_wizard("Which ruby version are you using with RVM (default: #{RUBY_VERSION})?")
gemset = ask_wizard("Which gemset do you want to use? (default: #{@app_name})") 

ruby_version = RUBY_VERSION if ruby_version.blank?
gemset = @app_name if gemset.blank?

run "rvm use #{ruby_version}"
run "rvm gemset create #{gemset}"

run "echo 'rvm use #{ruby_version}@#{gemset}' > .rvmrc"
