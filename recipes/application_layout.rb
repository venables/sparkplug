# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

after_bundler do
  say_wizard "HTML5 Boilerplate recipe running 'after bundler'"
  
  # Download HTML5 Boilerplate JavaScripts
  %w( modernizr-2.0.6.min.js ).each do |js_lib|
    get "https://raw.github.com/paulirish/html5-boilerplate/master/js/libs/#{js_lib}", "app/assets/javascripts/modernizr.js"
  end
  
  # Download app skeleton
  get "https://raw.github.com/necolas/normalize.css/master/normalize.css",          "app/assets/stylesheets/normalize.css.scss"
  get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css",      "app/assets/stylesheets/base.css.scss"
  get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css",    "app/assets/stylesheets/layout.css.scss"
  get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css",  "app/assets/stylesheets/skeleton.css.scss"
  get "https://raw.github.com/dhgamache/Skeleton/master/javascripts/tabs.js",       "app/assets/javascripts/tabs.js"
  
  
  # Download HTML5 Boilerplate Site Root Assets
  %w( 
    apple-touch-icon-114x114-precomposed.png
    apple-touch-icon-72x72-precomposed.png
    apple-touch-icon-57x57-precomposed.png
    apple-touch-icon-precomposed.png
    apple-touch-icon.png
    crossdomain.xml
    humans.txt
  ).each do |asset|
    get "https://raw.github.com/paulirish/html5-boilerplate/master/#{asset}", "public/#{asset}"
  end

  # ERB version of default application layout
  copy_template "app/views/devise/menu/_login_items.html.erb"
  copy_template"app/views/devise/menu/_registration_items.html.erb"

  copy_template "app/views/layouts/application.html.erb", :force => true
  gsub_file "app/views/layouts/application.html.erb", /AppName/, @app_name
end
