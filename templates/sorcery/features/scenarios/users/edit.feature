Feature: Edit user
  So that I can modify my account
  As a user
  I want to edit my account
  
  Scenario: User edits account with valid data
    Given I am logged in as "matt"
    When I update the user "matt" with:
      | Username              | matt          |
      | Email                 | matt@test.com |
    Then I should see "Your profile has been updated successfully"
    
  Scenario Outline: User edits account with invalid data
    Given I am logged in as "matt"
    When I update the user "matt" with:
      | Username              | <name>  |
      | Email                 | <email> |
    Then I should see "<error>"
    
    Examples:
      | username| email         | error             |
      | matt    | invalid       | Email is invalid  |