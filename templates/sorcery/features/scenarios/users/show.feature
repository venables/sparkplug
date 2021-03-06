Feature: Show user page
  So that I can see a profile
  As a user
  I want to see a user page
  
  Scenario: User can be seen by authenticated users
    Given the following users exist:
      | username| email         |
      | matt    | matt@test.com |
      | joe     | joe@test.com  |
    And I am logged in as "matt"
    When I am on the user detail page for "joe"
    Then I should see "joe" within "h1"
    And I should see "Email: joe@test.com"
      
  Scenario: User can not be seen by non-authenticated users
    Given the following users exist:
      | username| email         |
      | matt    | matt@test.com |
      | joe     | joe@test.com  |
    And I am not logged in
    When I am on the user detail page for "joe"
    Then I should be required to login