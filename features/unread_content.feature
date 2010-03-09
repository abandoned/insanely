Feature: Unread content
  In order to use Insane.ly
  As a disheveled genius
  I want to find out if a project has unread content
  
  Background:
    Given I am "john"
    And I am "jane"
    And I am logged in as "john"
    And a project "foo" exists with title: "foo", creator: user "john"
    And a participation exists with participant: user "jane", project: project "foo"
    
  Scenario: None of the projects has unread content
    Given I am on the path "/projects"
    Then there should be no unread content

  Scenario: John adds a task, Jane logs in to find project is updated
    Given I am on the path "/projects/1/tasks/active"
    When I add a task with the message "foobar"
    And I follow "Log out"
    And I log in as "jane"
    Then there should be unread content
  
  Scenario: John has an unread task, views it, and no longer has an unread task
    Given a task exist with project: project "foo", author: user "jane"
    And an unread exists with user: user "john", project: project "foo", readable: that task, readable_type: "Task"
    When I go to the path "/projects"
    Then there should be unread content
    When I go to the path "/projects/1/tasks/1"
    And I go to the path "/projects"
    Then there should be no unread content
  
  Scenario: John has an unread task, goes to the active tasks list, goes to the projects list, and no longer has unread content
    Given a task exist with project: project "foo", author: user "jane"
    And an unread exists with user: user "john", project: project "foo", readable: that task, readable_type: "Task"
    When I go to the path "/projects/1/tasks/active"
    And I go to the path "/projects"
    Then there should be no unread content
    
  Scenario: There is a read task, John adds a comment, following which Jane should have unread content
    Given a task exist with project: project "foo", author: user "jane"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Add a comment"
    And I fill in "comment_message" with "baz"
    And I press "Leave comment"
    And I follow "Log out"
    And I log in as "jane"
    Then there should be unread content
  
  Scenario: There is a read task, John adds a comment, following which Jane goes to the active tasks list and returns to the projects list. She should still have unread content.
    Given a task exist with project: project "foo", author: user "jane"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Add a comment"
    And I fill in "comment_message" with "baz"
    And I press "Leave comment"
    And I follow "Log out"
    And I log in as "jane"
    And I go to the path "/projects/1/tasks/active"
    Then there should be unread content
    When I go to the path "/projects"
    Then there should be unread content

  Scenario: There is a read task, John adds a comment, following which Jane goes to the task page and returns to the projects list. She should no longer have unread content.
    Given a task exist with project: project "foo", author: user "jane"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Add a comment"
    And I fill in "comment_message" with "baz"
    And I press "Leave comment"
    And I follow "Log out"
    And I log in as "jane"
    And I go to the path "/projects/1/tasks/1"
    And I go to the path "/projects"
    Then there should be no unread content
    When I go to the path "/projects/1/tasks/active"
    Then there should be no unread content
