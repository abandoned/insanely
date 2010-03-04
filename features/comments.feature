Feature: Comments
  In order to use Insane.ly
  As a disheveled genius
  I want to comment on tasks
  
  Background:
    Given I am logged in
    And a project "foo" exists with title: "foo", creator: user "me"
    And a task "bar" exists with project: project "foo", author: user "me"
  
  Scenario: Post a comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "baz"
    And I press "Leave comment"
    Then I should see "Comment created!"
    And I should see "baz"
    And a comment should exist with task: task "bar"
  
  Scenario: Delete a comment
    Given a comment exists with task: task "bar", author: user "me"
    And I am on the path "/projects/1/tasks/1"
    When I follow "Delete" within "#comment_1"
    Then 0 comments should exist
  
  Scenario: Delete a comment with blank message and attachment
    Given a comment_with_asset exists with task: task "bar", author: user "me", message: ""
    And I am on the path "/projects/1/tasks/1"
    When I follow "Delete" within "#comment_1"
    Then 0 comments should exist
  
  Scenario: Should not have option to delete someone else's comment
    Given a user "johndoe" exists with login: "johndoe", active: true
    And a comment exists with task: task "bar", author: user "johndoe"
    When I am on the path "/projects/1/tasks/1"
    Then I should not see "Delete" within "#comment_1"