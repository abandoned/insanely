Feature: Notifications
  In order to use Insane.ly
  As a user
  I want to receive email notifications
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a participation exists with project: project "My Project", participant: user "self"
      And a user "other" exists with password: "secret", password_confirmation: "secret", login: "other", email: "other@example.com", perishable_token: ""
      
  Scenario: Invite user to collaborate
    
  Scenario: Add workmate to project
  
  Scenario: Complete a project
  
  Scenario: Freeze a project
  
  Scenario: Delete a project