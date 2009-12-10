Feature: Projects
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete projects
  
  Background:
    Given I am logged in
        
  Scenario: Create and then edit a project
    Given I am on the path "/projects"
    When I follow "Create new project"
    And I fill in "Title" with "My New Project"
    And I press "Create project"
    Then I should see "My New Project" within "#header"
    When I go to the path "/projects/1/edit"
    And I fill in "Title" with "My Old Project"
    And I press "Update project"
    Then I should see "My Old Project" within "#header"
  
  Scenario: Drop-down select does not display projects I do not participate in
    Given a project exists with title: "Foo", creator: user "self"
    And a user "other" exists
    And a project exists with title: "Bar", creator: user "other"
    When I am on the path "/projects"
    Then I should see "Foo" within "#actions"
    But I should not see "Bar" within "#actions"