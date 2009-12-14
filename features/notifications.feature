Feature: Notifications
  In order to use Insane.ly
  As a user
  I want to notify others of my actions
  
  Background:
    Given I am logged in
    And a project "My Project" exists with title: "My Project", creator: user "self"
    And a task "My Task" exists with message: "lorem #ipsum", project: project "My Project", author: user "self"
      
  Scenario: Notify others of new task
    Given I am on the path "/projects/1/tasks"
    When I follow "Add task"
    And I fill in "task_message" with "foo bar"
    And I check "notify"
    And I press "Create task"
    Then 1 message should be queued for notification
  
  Scenario: Notify others of new comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "foo bar"
    And I check "notify"
    And I press "Leave comment"
    Then 1 message should be queued for notification
  
  Scenario: Do not notify others of new task
    Given I am on the path "/projects/1/tasks"
    When I follow "Add task"
    And I fill in "task_message" with "foo bar"
    And I press "Create task"
    Then 0 messages should be queued for notification
  
  Scenario: Do not notify others of new comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "foo bar"
    And I press "Leave comment"
    Then 0 messages should be queued for notification
  
  Scenario: Notify of completion of a task
    Given I am on the path "/projects/1/tasks/1"
    When I follow "Complete"
    Then 1 message should be queued for notification