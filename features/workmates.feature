Feature: Workmates
  In order to use Insane.ly
  As a disheveled genius
  I want to manage workmates
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    
  Scenario: Invite an existing user
    Given a user "jane" exists with login: "jane", email: "jane@example.com", active: true
    And I am on the path "/workmates"
    When I follow "Invite a person"
    And I fill in "Email" with "jane@example.com"
    And I press "Invite person"
    Then I should see "Added workmate!"
    Then I should see "jane"
    And I should see "pending"
