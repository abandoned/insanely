Feature: Unread content
  In order to use Insane.ly
  As a disheveled genius
  I want to know if a project or task has unread content
  
  Background:
    Given I am "john"
    And I am "jane"
    And I am logged in as "john"
    And a project "foo" exists with title: "foo", creator: user "john"
    And a participation exists with participant: user "jane", project: project "foo"
    
  Scenario: None of the projects has unread content.
    Given I am on the path "/projects"
    Then there should be no unread content

  Scenario: John adds a task. Jane logs in to find the project is updated.
    Given I am on the path "/projects/1/tasks/active"
    When I add a task with the message "foobar"
    And I follow "Log out"
    And I log in as "jane"
    Then there should be unread content
  
  Scenario: John has an unread task. He views it and thus no longer has an unread task.
    Given a task exist with project: project "foo", author: user "jane"
    And an unread exists with user: user "john", project: project "foo", readable: that task, readable_type: "Task"
    When I go to the path "/projects"
    Then there should be unread content
    When I go to the path "/projects/1/tasks/1"
    And I go to the path "/projects"
    Then there should be no unread content
  
  Scenario: John has an unread task. He views the active tasks and returns to the projects. He no longer has unread content.
    Given a task exist with project: project "foo", author: user "jane"
    And an unread exists with user: user "john", project: project "foo", readable: that task, readable_type: "Task"
    When I go to the path "/projects/1/tasks/active"
    And I go to the path "/projects"
    Then there should be no unread content
    
  Scenario: There is a read task. John adds a comment. Jane should have unread content
    Given a task exist with project: project "foo", author: user "jane"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Add a comment"
    And I fill in "comment_message" with "baz"
    And I press "Leave comment"
    And I follow "Log out"
    And I log in as "jane"
    Then there should be unread content
  
  Scenario: There is a read task. John adds a comment. Jane views the active tasks and returns to the projects. She should still have unread content.
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

  Scenario: There is a read task. John adds a comment. Jane views the task and returns to the projects. She should no longer have unread content.
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

  Scenario: There is a read task. John adds a comment and then deletes the task. Jane should not have unread content.
    Given a task exist with project: project "foo", author: user "jane"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Add a comment"
    And I fill in "comment_message" with "baz"
    And I press "Leave comment"
    And I follow "Delete"
    And I follow "Log out"
    And I log in as "jane"
    And I go to the path "/projects"
    Then there should be no unread content
    And 0 comments should exist