Feature: Projects
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete projects
  
  Background:
    Given I am logged in
        
  Scenario: Create and then edit a project
    Given I am on the path "/projects"
    When I follow "Create new project"
    And I fill in "Title" with "Foo"
    And I press "Create project"
    Then I should see "Foo" within "#header"
    And I should be on the path "/projects/1/edit"
    When I fill in "project_title" with "Bar"
    And I press "Update title"
    Then I should see "Bar" within "#header"
    And I should be on the path "/projects/1/edit"
    
  Scenario: Cannot create a project with duplicate name
    Given a project exists with title: "Foo", creator: user "self"
    And I am on the path "/projects"
    When I follow "Create new project"
    And I fill in "Title" with "Foo"
    And I press "Create project"
    Then I should see "Title must be unique"
    
  Scenario: Drop-down select does not display projects I do not participate in
    Given a project exists with title: "Foo", creator: user "self"
    And a user "other" exists
    And a project exists with title: "Bar", creator: user "other"
    When I am on the path "/projects"
    Then I should see "Foo" within "#actions"
    But I should not see "Bar" within "#actions"