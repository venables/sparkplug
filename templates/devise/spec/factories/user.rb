Factory.sequence(:user_name) do |n|
  "user_#{n}"
end

Factory.define :user do |u|
  u.name { Factory.next(:user_name) }
  u.email { |u| "#{u.name.downcase.underscore}@test.com"}
  u.password 'password'
end
