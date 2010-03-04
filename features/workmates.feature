Feature: Workmates
  In order to use Insane.ly
  As a disheveled genius
  I want to manage workmates
  
  Background:
    Given I am logged in
    
  Scenario: Invite an existing user
    Given a user "johndoe" exists with login: "johndoe", email: "john@foo.com", active: true
    And I am on the path "/workmates"
    When I follow "Invite a person"
    And I fill in "Email" with "john@foo.com"
    And I press "Invite person"
    Then I should see "Added workmate!"
    And I should have 1 workmate
