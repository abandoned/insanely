Feature: Workmates
  In order to use Insane.ly
  As a disheveled genius
  I want to invite and manage workmates already signed up on Insane.ly
  
  Background:
    Given I am "john"
    And a user "jane" exists with login: "jane", email: "jane@foo.com", active: true
    And I am logged in as "john"
    And I am on the path "/workmates"
    And I follow "Invite a person"
    And I fill in "Email" with "jane@foo.com"
    And I press "Invite person"
  
  Scenario: John has a pending workmate.
    Then I should see "Added workmate!"
    And I should see "jane"
    And I should see "pending"
  
  Scenario: Jane gets notification of invite
    Then a collaboration should exist
    And the user "Jane" should be that collaboration's invitee