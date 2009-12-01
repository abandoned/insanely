Feature: Tasks
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete tasks
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a participation exists with project: project "My Project", participant: user "self"
  
  Scenario: I should be able to destroy a task with no message and an attachment
    Given a task_with_asset "My task" exists with project: project "My Project", author: user "self", message: ""
      And I am on the path "/projects/1/tasks"
    When I follow "Delete"
    Then I should see "Task deleted!"