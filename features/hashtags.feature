Feature: Hashtags
  In order to use Insane.ly
  As a user
  I want to use hashtags when posting tasks and comments
  
  Background:
    Given I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
  
  Scenario: Create and then edit a task
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task"
    And I fill in "task_message" with "#Lorem #ipsum"
    And I press "Add task"
    Then I should see "lorem" within "#tag-cloud"
    And I should see "ipsum" within "#tag-cloud"
    And I should not see "dolor" within "#tag-cloud"
    When I follow "0 comments"
    And follow "Edit" within "#task_1"
    And I fill in "task_message" with "#Lorem ipsum"
    And I press "Update task"
    Then I should see "lorem" within "#tag-cloud"
    And I should not see "ipsum" within "#tag-cloud"
  
  Scenario: Create a task with no hashtag and then edit in a hashtag
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task" 
    And I fill in "task_message" with "Lorem ipsum"
    And I press "Add task"
    Then the DOM should not have selector "#tag-cloud"  
    When I follow "0 comments"
    And I follow "Edit" within "#task_1"
    And I fill in "task_message" with "#Lorem ipsum"
    And I press "Update task"
    Then I should see "lorem" within "#tag-cloud"
    And I should not see "untitled" within "#tag-cloud"
  
  Scenario: Create two tasks and then delete one
    Given I am on the path "/projects"
    When I follow "foo"
    And I follow "Add a task" 
    And I fill in "task_message" with "Lorem #ipsum #dolor sit amet"
    And I press "Add task"
    And I follow "Add a task" 
    And I fill in "task_message" with "#Lorem #ipsum dolor sit amet"
    And I press "Add task"
    Then I should see "lorem" within "#tag-cloud"
    And I should see "ipsum" within "#tag-cloud"
    And I should see "dolor" within "#tag-cloud"
    When I follow "Delete" within "#task_1"
    Then I should see "lorem" within "#tag-cloud"
    And I should see "ipsum" within "#tag-cloud"
    And I should not see "dolor" within "#tag-cloud"
  
  Scenario: Hashtag of a task with an attachment should destroy when task is destroyed
    Given a task exists with id: 1, project: project "foo", author: user "john", status: "active"
    And a task exists with id: 2, project: project "foo", author: user "john", status: "active", message: "#Lorem ipsum"
    And an asset exists with attachable_id: 2
    When I am on the path "/projects/1/tasks/2"
    Then I should see "lorem" within "#tag-cloud"
    When I follow "Delete" within "#task_2"
    Then the DOM should not have selector "#tag-cloud"
    
  Scenario: Hashtag of a task with an attachment should destroy if message is edited
    Given a task exists with id: 1, project: project "foo", author: user "john", status: "active", message: "Lorem ipsum"
    And an asset exists with attachable_id: 1, attachable_type: "Task"
    When I am on the path "/projects/1/tasks/1"
    Then the DOM should not have selector "#tag-cloud"
    When I follow "Edit"
    And I fill in "task_message" with "#Lorem ipsum"
    And I press "Update task"
    Then I should see "lorem" within "#tag-cloud"