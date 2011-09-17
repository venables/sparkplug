after_everything do
  
  say_wizard "Git recipe running 'after everything'"
  
  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'Create #{@app_name} app'"
  
  # Create a git branches
  git :checkout => ' -b staging'
  git :checkout => ' -b working'
end