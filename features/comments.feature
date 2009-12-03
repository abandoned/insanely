Feature: Hashtags
  In order to use Insane.ly
  As a user
  I want to create, edit, and delete comments
  
  Background:
    Given I am logged in
      And a project "My Project" exists with title: "My Project", creator: user "self"
      And a task "My Task" exists with message: "lorem #ipsum", project: project "My Project", author: user "self"
      
  Scenario: Post a comment
    Given I am on the path "/projects/1/tasks/1"
    When I fill in "comment_message" with "this is a #comment"
      And I press "Leave comment"
    Then I should see "this is a #comment"
      And I should see "ipsum" within ".tag-cloud"
      And I should see "comment" within ".tag-cloud"
  
  Scenario: I should be able to destroy a comment with no message and an attachment
    Given a comment_with_asset "My comment" exists with task: task "My Task", author: user "self", message: ""
      And I am on the path "/projects/1/tasks/1"
    When I follow "Delete" within ".comment"
    Then I should see "Comment deleted!"
