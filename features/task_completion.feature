Feature: Task Completion
  In order to use Insane.ly
  As a disheveled genius
  I want to complete tasks
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
    And a task "bar" exists with message: "bar", project: project "foo", author: user "john"
  
  Scenario: Complete a task
    Given I am on the path "/projects/1/tasks/active"
    When I follow "Complete" within "#task_1"
    Then task "bar" should be completed
    When I go to path "/projects/1/tasks/active"
    Then I should not see "bar"
    When I go to path "/projects/1/tasks/completed"
    Then I should see "bar"
  
  Scenario: Search for a completed tasks
    Given task "bar" is completed
    And I am on the path "/projects/1/tasks/active"
    Then I should not see "bar"
    When I fill in "query" with "bar"
    And I press "Search"
    Then I should see "bar" within "#tasks"
  
  Scenario: Return to list of completed tasks after deleting task there
    Given task "bar" is completed
    And a task "baz" exists with project: project "foo", author: user "john", message: "baz", status: "completed"
    And I am on the path "/projects/1/tasks/completed"
    When I follow "Delete" within "#task_2"
    Then I should be on path "/projects/1/tasks/completed"
    And I should see "bar"
    And I should not see "baz"