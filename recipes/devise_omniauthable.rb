config = {}
config['omniauthable'] = yes_wizard?("Do you want to allow users to sign in using facebook or twitter?")
config['facebook'] = yes_wizard?("Do you want to use facebook authentication?")

if config['facebook']
  config['facebook_id'] = ask_wizard("What is your facebook app id?")
  config['facebook_secret'] = ask_wizard("What is your facebook app secret?")
end

config['twitter'] = yes_wizard?("Do you want to use twitter authentication?")
if config['twitter']
  config['twitter_id'] = ask_wizard("What is your twitter consumer key?")
  config['twitter_secret'] = ask_wizard("What is your twitter consumer secret?")
end

if config['facebook'] || config['twitter']
  say_wizard "DeviseOmniauthable recipe using facebook and/or twitter"
  
  gem "omniauth", :git => "git://github.com/intridea/omniauth.git", :branch => "0-3-stable"
    
  after_bundler do
    say_wizard "DeviseOmniauthable recipe running 'after bundler'"
      
    inject_into_file 'config/initializers/devise.rb', :before => '# config.omniauth' do
      configs = []
      configs << "config.omniauth :facebook, '#{config['facebook_id']}', '#{config['facebook_secret']}'" if config['facebook']
      configs << "config.omniauth :twitter, '#{config['twitter_id']}', '#{config['twitter_secret']}'" if config['twitter']
      configs.compact.join("\n  ") + "\n"
    end

    gsub_file "app/models/user.rb", /devise :database_authenticatable/, "devise :omniauthable, :database_authenticatable"
      
    generate "model Authentication user_id:integer provider:string uid:string data:text"
      
    inject_into_file "app/models/user.rb", :after => ":remember_me" do
      contents_of_file template_path("user.rb")
    end
    
    append_file "app/views/users/show.html.erb", contents_of_file(template_path("show.html.erb"))
      
    gsub_file "config/routes.rb", /devise_for :users/, do
      contents_of_file template_path("devise_routes.rb")
    end
      
    gsub_file "config/routes.rb", /resources :users, :only => [:index, :show]/, do 
      contents_of_file template_path("user_routes.rb")
    end
    
    %w(
      app/controllers/authentications_controller.rb
      app/controllers/users/omniauth_callbacks_controller.rb
      app/controllers/users/registrations_controller.rb
      app/models/authentication.rb
      app/views/authentications/index.html.erb
      app/views/authentications/_authentication.html.erb
    ).each do |f|
      copy_template f
    end
      

    copy_file "#{destination_root}/app/views/devise/registrations/new.html.erb", "app/views/users/registrations/new.html.erb"
    copy_file "#{destination_root}/app/views/devise/registrations/edit.html.erb", "app/views/users/registrations/edit.html.erb"
        
    inject_into_file "app/views/users/registrations/new.html.erb", :before => "<p><%= f.label :password %><br />" do
      "  <% if resource.password_required? %>\n  "
    end
    
    inject_into_file "app/views/users/registrations/new.html.erb", :after => "<%= f.password_field :password_confirmation %></p>" do
      "\n  <% end %>"
    end   
      
    if config['facebook']
      inject_into_file "app/controllers/users/omniauth_callbacks_controller.rb", :after => "Devise::OmniauthCallbacksController" do
        "\n  def facebook\n    authenticate_with('facebook')\n  end"
      end
    end
      
    if config['twitter']
      inject_into_file "app/controllers/users/omniauth_callbacks_controller.rb", :after => "Devise::OmniauthCallbacksController" do
        "\n  def twitter\n    authenticate_with('twitter')\n  end"
      end
    end
      
  end
end









