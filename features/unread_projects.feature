Feature: Unread projects
  In order to use Insane.ly
  As a disheveled genius
  I want to see projects that contain unread content
  
  Background:
    Given I am logged in
    And a user "johndoe" exists with login: "johndoe", active: true
    And a project "foo" exists with title: "foo", creator: user "user"
    And a project "bar" exists with title: "bar", creator: user "user"
    And a participation exists with participant: user "johndoe", project: project "foo"
    And 1 second has elapsed
    And a task "baz" exists with author: user "johndoe", project: project "bar"
  
  Scenario: Project with unread content
    Given I am on the path "/projects/1/tasks/active"
    Then the HTML should not contain ".circle" within "#project_1"
    And the HTML should contain ".circle" within "#project_2"