Given /^the user "([^"]*)" exists$/ do |email|
  unless User.where(:email => email).exists?
    Factory.create(:user, { 'email' => email })
  end
end

When /^I update my account with:$/ do |fields|
  Given %{I am on the edit user page}
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
  And %{I press "Update"}
end