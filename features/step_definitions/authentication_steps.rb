Given /^I am logged in$/ do
  steps %Q{
    Given a user: "self" exists with login: "self", password: "secret", active: true
    And I am on path "user_session/new"
    And I fill in "Username" with "self"
    And I fill in "Password" with "secret"
    And I press "Log in"
  }
end