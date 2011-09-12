Given /^I am not logged in$/ do
  Given %{I sign out}
end

Given /^I am logged in$/ do
  Given %{I am logged in as "matt@test.com"}
end

Given /^I am logged in as "([^"]*)"$/ do |email|
  Given %{the user "#{email}" exists}
  When %{I log in as "#{email}"}
end


When /^I sign up with:$/ do |fields|
  Given %{I am on the sign up page}
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
  And %{I press "Sign up"}
end

When /^I log in as "([^"]*)"$/ do |email|
  When %{I log in as "#{email}" with password "password"}
end

When /^I log in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end

Then /^I sign out$/ do
  visit '/users/sign_out'
end

Then /^I should be logged in$/ do
  Then %{I should see "Signed in successfully."}
end

Then /^I should not be logged in$/ do
  Then %{I should not see "Log out"}
end

Then /^I should not be logged in due to invalid email or password$/ do
  Then %{I should not be logged in}
  Then %{I should see "Invalid email or password."}
end

Then /^I should be required to sign in$/ do
  Then %{I should see "You need to sign in or sign up before continuing."}
  Then %{I should be on the sign in page}
end