Feature: Complete Tasks
  In order to use Insane.ly
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
  
  Scenario: I should be able to search completed tasks
    Given a task "Completed Task" exists with message: "foo #completed", project: project "My Project", author: user "self", status: "completed"
      And I am on the path "/projects/1/tasks?status=completed"
    Then I should see "foo #completed"
    When I fill in "query" with "foo #completed"
      And I press "Search"
    Then I should see "foo #completed"
  
  Scenario: I should return to the list of completed tasks when I delete a task there
    Given a task "1st Completed Task" exists with message: "foo #completed", project: project "My Project", author: user "self", status: "completed"
      And a task "2nd Completed Task" exists with message: "bar #completed", project: project "My Project", author: user "self", status: "completed"
      And I am on the path "/projects/1/tasks?status=completed"
    When I follow "Delete" within "#task_2"
    Then I should be on path "/projects/1/tasks"
      And my query string should be "status=completed"
      And I should see "bar #completed"