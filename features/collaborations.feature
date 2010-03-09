Feature: Collaborations
  In order to use Insane.ly
  As a disheveled genius
  I want to manage workmates
  
  Background:
    Given I am "jane"
    And I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
    And a collaboration exists with user: user "john", workmate: user "jane", status: "active"
    And a collaboration exists with user: user "jane", workmate: user "john", status: "active"
  
  Scenario: Add a user to a project
    Given I am on the path "/projects/1/edit"
    Then I should see "john" within ".participations"
    And I should not see "jane" within ".participations"
    When I follow "Add new person"
    And I select "jane" from "Workmate"
    And I press "Add to project"
    Then I should see "Person added to project!"
    And I should see "jane" within ".participations"
  
  Scenario: Creator removes a person from project
    Given a participation exists with project: project "foo", participant: user "jane"
    And I am on the path "/projects/1/edit"
    Then I should see a button called "Remove »" within "#participation_2"
    When I press "Remove" within "#participation_2"
    Then I should see "Person removed from project!"
    And I should see "john" within ".participations"
    And I should not see "jane" within ".participations"
  
  Scenario: Creator cannot remove herself from project
    Given I am on the path "/projects/1/edit"
    Then I should not see a button called "Remove »" within "#participation_1"
  
  Scenario: Non-creator removes herself from project
    Given a project "Bar" exists with creator: user "jane"
    And a participation exists with project: project "Bar", participant: user "john"
    When I am on the path "/projects/2/edit"
    And I press "Remove" within "#participation_3"
    Then I should see "Person removed from project!"
    And I should be on path "/projects"
  
  Scenario: Non-creator cannot remove others from project
    Given a project "Bar" exists with creator: user "jane"
    And a participation exists with project: project "Bar", participant: user "john"
    When I am on the path "/projects/2/edit"
    Then I should not see a button called "Remove »" within "#participations_2"