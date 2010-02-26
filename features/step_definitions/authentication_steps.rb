Given /^I am logged in$/ do
  steps %Q{
    Given a user: "user" exists with login: "user", password: "secret", email: "foo@example.com", active: true
    And I am on path "user_session/new"
    And I fill in "Username" with "user"
    And I fill in "Password" with "secret"
    And I press "Log in"
  }
end