Feature: Hashtags
  In order to organize tasks
  As a user
  I want to create and delete assignments
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a participation exists with project: project "My Project", participant: user "self"
    
  Scenario: Create and then edit a task
    Given I am on the path "/projects"
    When I follow "My Project"
      And I follow "Add task" 
      And I fill in "task_message" with "@self"
      And I press "Create task"
    Then I should see "1" within "#assignment-count"
    When I follow "0 comments"
      And I fill in "comment_message" with "-@self"
      And I press "Leave comment"
    Then I should see "0" within "#assignment-count"