Feature: Edit user
  So that I can modify my account
  As a user
  I want to edit my account
  
  Scenario: User edits account with valid data
    Given I am logged in as "matt@test.com"
    When I update my account with:
      | Name                  | matt          |
      | Email                 | matt@test.com |
      | Password              | password      |
      | Password confirmation | password      |
      | Current password      | password      |
    Then I should see "You updated your account successfully."
    
  Scenario Outline: User edits account with invalid data
    Given I am logged in as "matt@test.com"
    When I update my account with:
      | Name                  | <name >                 |
      | Email                 | <email>                 |
      | Password              | <password>              |
      | Password confirmation | <password_confirmation> |
      | Current password      | <current_password>      |
    Then I should see "<error>"
    
    Examples:
      | name    | email         | password    | password_confirmation | current_password  | error                               |
      | matt    | invalid       | testing     | testing               | password          | Email is invalid                    |
      | matt    | matt@test.com |             | testing               | password          | Password can't be blank             |
      | matt    | matt@test.com | testing     |                       | password          | Password doesn't match confirmation |
      | matt    | matt@test.com | testing     | testing123            | password          | Password doesn't match confirmation |
      | matt    | matt@test.com | test        | test                  | password          | Password is too short               |
      | matt    | matt@test.com | testing     | testing               |                   | Current password can't be blank     |
      | matt    | matt@test.com | testing     | testing               | bad               | Current password is invalid         |