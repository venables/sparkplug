@current_recipe = nil

# >-----------------------------[ Run Bundler ]-------------------------------<

say_wizard "Running 'bundle install'. This will take a while."
run 'bundle install'
say_wizard "Running 'after bundler' callbacks."
require 'bundler/setup'
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Running 'after everything' callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

run 'rake db:create'
run 'rake db:migrate'

@current_recipe = nil
say_wizard "Finished running the rails_apps_composer app template."
say_wizard "Your new Rails app is ready. Any problems?"
say_wizard "See http://github.com/RailsApps/rails_apps_composer/issues"
