gem "friendly_errors"

after_bundler do
  say_wizard "Enabling FriendlyErrors"
  inject_into_file 'app/controllers/application_controller.rb', "\n  include FriendlyErrors\n  use_friendly_errors", :after => /protect_from_forgery/
end
