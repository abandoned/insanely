Feature: Assignemnts
  In order to use Insane.ly
  As a user
  I want to be able to assign tasks
  
  Background:
    Given I am logged in
    And a project "foo" exists with title: "foo", creator: user "user"
  
  Scenario: Assign in task
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task" 
    And I fill in "task_message" with "@user"
    And I press "Add task"
    Then I should see "1" within "#assignment-count"
  
  Scenario: Assign in comment
    Given a task "bar" exists with project: project "foo"
    And I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "@user"
    And I press "Leave comment"
    Then I should see "1" within "#assignment-count"
  
  Scenario: 