Feature: Complete Tasks
  In order to organize tasks
  As a user
  I want to complete tasks
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a participation exists with project: project "My Project", participant: user "self"
      And a task "My Task" exists with message: "lorem #ipsum", project: project "My Project", author: user "self"
  
  Scenario: I should be able to complete a task
    Given I am on the path "/projects/1/tasks"
    When I follow "Complete" within "#task_1"
    Then I should see "Task completed!"
    When I go to path "/projects/1/tasks?status=completed"
    Then I should see "lorem #ipsum"