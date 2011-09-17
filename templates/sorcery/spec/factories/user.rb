Factory.sequence(:user_username) do |n|
  "user#{n}"
end

Factory.define :user do |u|
  u.username { Factory.next(:user_username) }
  u.email { |u| "#{u.username.downcase.underscore}@test.com"}
  u.password 'password'
end

