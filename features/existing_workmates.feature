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
    And I fill in "Login of workmate" with "jane"
    And I press "Add workmate"
  
  Scenario: John has a requested workmate
    Then a collaboration should exist with user: user "john", workmate: user "jane", status: "requested"
    And I should see "Added workmate!"
    And I should see "jane"
    And I should see "requested"
  
  Scenario: Jane activates pending workmate
    Then a collaboration should exist with user: user "jane", workmate: user "john", status: "pending"
    And I am on path "/logout"
    Given I log in as "jane"
    When I am on the path "/workmates"
    Then I should see "john"
    And I should see "pending"
    When I follow "Activate"
    Then I should see "Collaboration activated!"
    And a collaboration should exist with user: user "jane", workmate: user "john", status: "active"
    And a collaboration should exist with user: user "john", workmate: user "jane", status: "active"
  
  Scenario: Jane removes pending workmate
    Then a collaboration should exist with user: user "jane", workmate: user "john", status: "pending"
    And I am on path "/logout"
    Given I log in as "jane"
    When I am on the path "/workmates"
    Then I should see "john"
    And I should see "pending"
    When I follow "Remove"
    Then I should see "Collaboration removed!"
    And a collaboration should not exist with user: user "jane", workmate: user "john"
    And a collaboration should not exist with user: user "john", workmate: user "jane"
