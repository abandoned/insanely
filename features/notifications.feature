Feature: Notifications
  In order to use Insane.ly
  As a user
  I want to notify others of my actions
  
  Background:
    Given I am "jane"
    And I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
    And a participation exists with project: project "foo", participant: user "jane"
    And a task "bar" exists with message: "lorem #ipsum", project: project "foo", author: user "john"
  
  Scenario: Notify others of new task
    Given I am on the path "/projects/1/tasks"
    When I follow "Add a task"
    And I fill in "task_message" with "foo bar"
    And I check "notify"
    And I press "Add task"
    Then 1 message should be queued for notification
  
  Scenario: Notify others of new comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "foo bar"
    And I check "notify"
    And I press "Leave comment"
    Then 1 message should be queued for notification
  
  Scenario: Do not notify others of new task
    Given I am on the path "/projects/1/tasks"
    When I follow "Add a task"
    And I fill in "task_message" with "foo bar"
    And I press "Add task"
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