Feature: Workmates
  In order to use Insane.ly
  As a disheveled genius
  I want to invite and manage workmates already signed up on Insane.ly
  
  Background:
    Given I am "john"
    And a user "jane" exists with login: "jane", email: "jane@foo.com", active: true
    And I am logged in as "john"
    And I am on the path "/workmates"
    And I follow "Add a person"
    And I fill in "Email" with "jane@foo.com"
    And I press "Add person"
  
  Scenario: John has a pending workmate.
    Then I should see "Added workmate!"
    And I should see "jane"
    And I should see "pending"
  
  Scenario: Jane is invited and gets notification of invite
    Then a collaboration should exist
    And that collaboration should be one of user "Jane"'s invites