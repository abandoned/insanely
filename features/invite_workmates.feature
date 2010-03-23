Feature: Workmates
  In order to use Insane.ly
  As a disheveled genius
  I want to invite workmates new to Insane.ly
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    And I am on the path "/workmates"
    And I follow "Invite a person"
    And I fill in "Email" with "jane@foo.com"
    And I press "Invite person"
  
  Scenario: John has a pending workmate.
    Then I should see "Invite workmate!"
    And I should see "jane"
    And I should see "pending"