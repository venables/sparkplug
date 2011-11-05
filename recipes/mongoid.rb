@use_mongo = yes_wizard?("Do you want to use mongoid w/ mongodb?")

if @use_mongo
  gem "mongoid", "~> 2.2"
  gem "bson_ext", "~> 1.3"

  after_bundler do
    generate "mongoid:config"
  end
end