Feature: Participants
  In order to use Insane.ly
  As a user
  I want to add participants to and remove them from projects
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a user "other" exists with password: "secret", login: "jdoe", email: "other@example.com", active: true
      And a collaboration exists with user: user "self", workmate: user "other", status: "active"
      And a collaboration exists with user: user "other", workmate: user "self", status: "active"
      
  Scenario: Add a user to a project
    Given I am on the path "/projects/1/participants"
    Then I should see "This project has 1 participant."
      And I should see "self"
      And I should not see "jdoe"
    When I follow "Add a person"
      And I select "jdoe" from "participant_participant_id"
      And I press "Add to project"
    Then I should see "This project has 2 participants."
      And I should see "jdoe"
    
    
  Scenario: Creator removes a person from project
  
  Scenario: Non-creator cannot remove a person from project
  
  Scenario: Creator cannot remove itself from project
  
  Scenario: Participant adds a person from project