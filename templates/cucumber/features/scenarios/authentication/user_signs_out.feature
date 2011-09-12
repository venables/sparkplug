Feature: User signs out
  So that I can leave this computer safely
  As a user
  I want to sign out
  
  Scenario: User authenticates successfully
    Given I am logged in
    When I sign out
    Then I should not be logged in