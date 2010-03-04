Given /^I add a task with the message "(\w+)"$/ do |message|
  steps %Q{
    When I follow "Add a task"
    And I fill in "task_message" with "#{message}"
    And I press "Add task"
  }
end

Given /^#{capture_model} is (.+)$/ do |name, status|
  model(name).update_attribute(:status, status)
end