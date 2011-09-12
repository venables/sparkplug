after_everything do
  
  say_wizard "Git recipe running 'after everything'"
  
  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'Create #{@app_name} app"
  
  # Create a git branch
  git :checkout => ' -b working'
  git :add => '.'
  git :commit => "-m 'Initial commit of working branch'"
  git :checkout => 'master'
end