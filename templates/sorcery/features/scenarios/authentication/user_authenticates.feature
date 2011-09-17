Feature: User authenticates
  So that I can log in to my account
  As a user
  I want to authenticate
  
  Scenario: User authenticates successfully
    Given I am not logged in
    And the user "matt" exists
    When I log in as "matt"
    Then I should be logged in
  
  Scenario: User enters wrong password
    Given I am not logged in
    And the user "matt" exists
    When I log in as "matt" with password "bad"
    Then I should not be logged in due to invalid username or password
    
  Scenario: User does not have an account
    Given I am not logged in
    And there are 0 users
    When I log in as "matt"
    Then I should not be logged in due to invalid username or password
