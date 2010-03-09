Feature: Projects
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete projects
  
  Background:
    Given I am "jane"
    And I am "john"
    And I am logged in as "john"
        
  Scenario: Create and then edit a project
    Given I am on the path "/projects"
    When I follow "Create a new project"
    And I fill in "Title" with "Foo"
    And I press "Create project"
    Then I should see "Foo" within "#header"
    And I should be on the path "/projects/1/tasks/active"
    When I follow "Edit project"
    And I fill in "project_title" with "Bar"
    And I press "Update project"
    Then I should see "Bar" within "#header"
    And I should be on the path "/projects/1/edit"
    
  Scenario: Cannot Create a new project with duplicate name
    Given a project exists with title: "foo", creator: user "john"
    And I am on the path "/projects"
    When I follow "Create a new project"
    And I fill in "Title" with "foo"
    And I press "Create project"
    Then I should see "Title must be unique"
    
  Scenario: Project list does not display projects I do not participate in
    Given a project exists with title: "foo", creator: user "john"
    And a project exists with title: "bar", creator: user "jane"
    When I am on the path "/projects"
    Then I should see "foo" within "#projects"
    But I should not see "bar" within "#projects"
  
  Scenario: Archive a project
    Given a project: "foo" exists with title: "foo", creator: user "john"
    And I am on the path "/projects/1/edit"
    When I follow "Archive project"
    Then I should see "Project archived!"
    And I should not see "foo"
    And the project: "foo" should exist with status: "archived"
    When I go to the path "/projects/archived"
    Then I should see "foo"