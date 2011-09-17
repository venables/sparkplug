gem 'simplecov', :require => false, :group => :test

after_bundler do
  ["features/support/env.rb", "spec/spec_helper.rb"].each do |f|
    prepend_file f, "require 'simplecov'\nSimpleCov.start 'rails'"
  end
end