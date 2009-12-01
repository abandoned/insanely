Feature: Participants
  In order to use Insane.ly
  As a user
  I want to add participants to and remove them from projects
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a participation exists with project: project "My Project", participant: user "self"
      And a user "other" exists with password: "secret", password_confirmation: "secret", login: "other", email: "other@example.com"
      And that user is activated
      And a collaboration exists with user: user "self", workmate: user "other", status: "active"
      And a collaboration exists with user: user "other", workmate: user "self", status: "active"
      And inspect the workmates of user: "self"
      
  Scenario: Add a user to a project
    Given I am on the path "/projects/1/participants"
    
    
  Scenario: Creator removes a person from project
  
  Scenario: Non-creator cannot remove a person from project
  
  Scenario: Creator cannot remove itself from project
  
  Scenario: Participant adds a person from project