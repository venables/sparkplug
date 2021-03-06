Feature: User registers for the website
  So that I can use the website
  As a user
  I want to register for an account
  
  Scenario: User registers with valid data
    Given I am not logged in
    When I sign up with:
      | Username              | matt          |
      | Email                 | matt@test.com |
      | Password              | password      |
      | Password confirmation | password      |
    Then I should see "Signed up!"
  
  Scenario Outline: User registers with invalid data
    Given I am not logged in
    When I sign up with:
      | Username              | <name >                 |
      | Email                 | <email>                 |
      | Password              | <password>              |
      | Password confirmation | <password_confirmation> |
    Then I should see "<error>"
    
    Examples:
      | username| email         | password    | password_confirmation | error                               |
      | matt    | invalid       | testing     | testing               | Email is invalid                    |
      | matt    | matt@test.com |             | testing               | Password can't be blank             |
      | matt    | matt@test.com | test        | test                  | Password is too short               |
      | matt    | matt@test.com | testing     |                       | Password should match confirmation  |
      | matt    | matt@test.com | testing     | testing123            | Password should match confirmation  |
