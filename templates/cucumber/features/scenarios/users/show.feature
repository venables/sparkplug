Feature: Show user page
  So that I can see a profile
  As a user
  I want to see a user page
  
  Scenario: User can be seen by authenticated users
    Given the following users exist:
      | name    | email         |
      | matt    | matt@test.com |
      | joe     | joe@test.com  |
    And I am logged in as "matt@test.com"
    When I am on the user detail page for "joe@test.com"
    Then I should see "User: joe"
    And I should see "Email: joe@test.com"
      
  Scenario: User can not be seen by non-authenticated users
    Given the following users exist:
      | name    | email         |
      | matt    | matt@test.com |
      | joe     | joe@test.com  |
    And I am not logged in
    When I am on the user detail page for "joe@test.com"
    Then I should be required to sign in