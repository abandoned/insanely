Given /^I am "(\w+)"$/ do |login|
  steps %Q{
    Given a user "#{login}" exists with login: "#{login}", password: "secret", active: true
  }
end

Given /^I (?:am logged|log) in as "(\w+)"$/ do |login|
  steps %Q{
    And I am on path "session/new"
    And I fill in "Username" with "#{login}"
    And I fill in "Password" with "secret"
    And I press "Log in"
  }
end

def current_user_session
  @current_user_session ||= UserSession.find
end

def current_user
  @current_user ||= current_user_session && current_user_session.user
end