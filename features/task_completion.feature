Feature: Task Completion
  In order to use Insane.ly
  As a disheveled genius
  I want to complete tasks
  
  Background:
    Given I am logged in
    And a project "foo" exists with title: "foo", creator: user "user"
    And a task "foobar" exists with project: project "foo", author: user "user", message: "foobar"
  
  Scenario: Complete a task
    Given I am on the path "/projects/1/tasks/active"
    When I follow "Complete" within "#task_1"
    Then task "foobar" should be completed
    When I go to path "/projects/1/tasks/active"
    Then I should not see "foobar"
    When I go to path "/projects/1/tasks/completed"
    Then I should see "foobar"
  
  Scenario: Search for a completed tasks
    Given task "foobar" is completed
    And I am on the path "/projects/1/tasks/active"
    Then I should not see "foobar"
    When I fill in "query" with "foobar"
    And I press "Search"
    Then I should see "foobar" within "#tasks"
  
  Scenario: Return to list of completed tasks after deleting task there
    Given task "foobar" is completed
    And a task "foobaz" exists with project: project "foo", author: user "user", message: "foobaz", status: "completed"
    And I am on the path "/projects/1/tasks/completed"
    When I follow "Delete" within "#task_2"
    Then I should be on path "/projects/1/tasks/completed"
    And I should see "foobar"
    And I should not see "foobaz"