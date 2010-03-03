@wip
Feature: Collaborations
  In order to use Insane.ly
  As a disheveled genius
  I want to manage workmates
  
  Background:
    Given I am logged in
    And a project "foo" exists with creator: user "user"
    And a user "johndoe" exists with login: "johndoe", active: true
    And a collaboration exists with user: user "user", workmate: user "johndoe", status: "active"
    And a collaboration exists with user: user "johndoe", workmate: user "user", status: "active"
  
  Scenario: Add a user to a project
    Given I am on the path "/projects/1/edit"
    Then I should see "self" within ".participations"
    And I should not see "jdoe" within ".participations"
    When I follow "Add new person"
    And I select "jdoe" from "Workmate"
    And I press "Add to project"
    Then I should see "Person added to project!"
    And I should see "jdoe" within ".participations"
  
  Scenario: Creator removes a person from project
    Given a participation exists with project: project "My Project", participant: user "other"
    And I am on the path "/projects/1/edit"
    Then I should see a button called "Remove »" within "#participation_2"
    When I press "Remove" within "#participation_2"
    Then I should see "Person removed from project!"
    And I should see "self" within ".participations"
    And I should not see "jdoe" within ".participations"
  
  Scenario: Creator cannot remove herself from project
    Given I am on the path "/projects/1/edit"
    Then I should not see a button called "Remove »" within "#participation_1"
  
  Scenario: Non-creator removes herself from project
    Given a project "Someone Else's Project" exists with creator: user "other"
    And a participation exists with project: project "Someone Else's Project", participant: user "self"
    When I am on the path "/projects/2/edit"
    And I press "Remove" within "#participation_3"
    Then I should see "Person removed from project!"
    And I should be on path "/projects"
  
  Scenario: Non-creator cannot remove others from project
    Given a project "Someone Else's Project" exists with creator: user "other"
    And a participation exists with project: project "Someone Else's Project", participant: user "self"
    When I am on the path "/projects/2/edit"
    Then I should not see a button called "Remove »" within "#participations_2"