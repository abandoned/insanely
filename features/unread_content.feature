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
    Then the DOM should not have selector ".circle"

  Scenario: John adds a task, Jane logs in to find project is updated
    Given I am on the path "/projects/1/tasks/active"
    When I add a task with the message "foobar"
    And I follow "Log out"
    And I log in as "jane"
    Then the DOM should have selector ".circle"
  
  Scenario: John has an unread task, views it, and no longer has an unread task
    Given a task exist with project: project "foo", author: user "jane"
    And an unread exists with user: user "john", project: project "foo", readable: that task, readable_type: "Task"
    When I go to the path "/projects"
    Then the DOM should have selector ".circle"
    When I go to the path "/projects/1/tasks/1"
    And I go to the path "/projects"
    Then the DOM should not have selector ".circle"
