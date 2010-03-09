Feature: Tasks
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete tasks
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
  
  Scenario: I should be able to destroy a task with no message and an attachment
    Given a task_with_asset "bar" exists with project: project "foo", author: user "john", message: ""
    And I am on the path "/projects/1/tasks"
    When I follow "Delete"
    Then I should see "Task deleted!"