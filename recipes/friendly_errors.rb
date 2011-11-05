unless @use_mongo
  gem "friendly_errors"

  after_bundler do
    say_wizard "Enabling FriendlyErrors"
  
    inject_into_file "app/controllers/application_controller.rb", :after => /ActionController::Base/ do
      "\n  include FriendlyErrors\n"
    end
  
    inject_into_file "app/controllers/application_controller.rb", :after => /protect_from_forgery/ do
      "\n  use_friendly_errors"
    end
  
  end
end