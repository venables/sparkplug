Given /^I am not logged in$/ do
  Given %{I sign out}
end

Given /^I am logged in$/ do
  Given %{I am logged in as "matt"}
end

Given /^I am logged in as "([^"]*)"$/ do |username|
  Given %{the user "#{username}" exists}
  When %{I log in as "#{username}"}
end


When /^I sign up with:$/ do |fields|
  Given %{I am on the sign up page}
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
  And %{I press "Sign up"}
end

When /^I log in as "([^"]*)"$/ do |username|
  When %{I log in as "#{username}" with password "password"}
end

When /^I log in as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  When %{I go to the login page}
  And %{I fill in "Username" with "#{username}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Log in"}
end

Then /^I sign out$/ do
  When %{I go to the logout page}
end

Then /^I should be logged in$/ do
  Then %{I should see "Logged in!"}
end

Then /^I should not be logged in$/ do
  Then %{I should not see "Log out"}
end

Then /^I should not be logged in due to invalid username or password$/ do
  Then %{I should not be logged in}
  Then %{I should see "Username or password was invalid"}
end

Then /^I should be required to login$/ do
  Then %{I should see "Please log in."}
  Then %{I should be on the login page}
end