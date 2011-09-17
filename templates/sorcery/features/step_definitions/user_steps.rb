Given /^the user "([^"]*)" exists$/ do |username|
  unless User.where(:username => username).exists?
    Factory.create(:user, { 'username' => username })
  end
end

When /^I update the user "([^"]*)" with:$/ do |username, fields|
  Given %{I am on the edit user page for "#{username}"}
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
  And %{I press "Update"}
end