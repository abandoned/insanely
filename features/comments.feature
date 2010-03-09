Feature: Comments
  In order to use Insane.ly
  As a disheveled genius
  I want to comment on tasks
  
  Background:
    Given I am "jane"
    And I am "john"
    And I am logged in as "john"
    And a project "foo" exists with creator: user "john"
    And a task "bar" exists with project: project "foo", author: user "john"
  
  Scenario: Post a comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "baz"
    And I press "Leave comment"
    Then I should see "Comment created!"
    And I should see "baz"
    And a comment should exist with task: task "bar"
  
  Scenario: Delete a comment
    Given a comment exists with task: task "bar", author: user "john"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Delete" within "#comment_1"
    Then 0 comments should exist
  
  Scenario: Delete a comment with blank message and attachment
    Given a comment_with_asset exists with task: task "bar", author: user "john", message: ""
    And I am on the path "/projects/1/tasks/1"
    When I follow "Delete" within "#comment_1"
    Then 0 comments should exist
  
  Scenario: Should not have option to delete someone else's comment
    Given a comment exists with task: task "bar", author: user "jane"
    When I am on the path "/projects/1/tasks/1"
    Then I should not see "Delete" within "#comment_1"