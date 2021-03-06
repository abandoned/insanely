Feature: Assignments
  In order to use Insane.ly
  As a disheveled genius
  I want to assign tasks to users
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    And a project "foo" exists with title: "foo", creator: user "john"
  
  Scenario Outline: Assign in task
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task" 
    And I fill in "task_message" with "<message>"
    And I press "Add task"
    Then I should see "1" within "#assignment-count"
    When I follow "@john"
    Then I should be on the path "/projects/1/participants/1/tasks/assigned"
    
    Examples:
      | message       |
      | @john         |
      | foo @john     |
      | @john foo     |
      | foo @john bar |
  
  Scenario Outline: Do not assign if user name is not self or workmate
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task" 
    And I fill in "task_message" with "<message>"
    And I press "Add task"
    Then the DOM should not have selector "#assignment-count"
    
    Examples:
      | message  |
      | @johnfoo |
      | foo@john |
  
  Scenario: Assign in comment
    Given a task "bar" exists with project: project "foo", author: user "john"
    And I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "@john"
    And I press "Leave comment"
    Then I should see "1" within "#assignment-count"
  
  Scenario: Display an assignment count on list of projects
    Given a task "bar" exists with project: project "foo", author: user "john", message: "@john"
    And a task "baz" exists with project: project "foo", author: user "john", message: "@john"
    When I am on the path "/projects"
    Then I should see "2" within ".assignment-count"
