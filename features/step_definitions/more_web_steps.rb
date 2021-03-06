Then /^I should see a button called "([^\"]*)"$/ do |button|
  response.should have_selector("input[type='submit']", :value => button)
end

Then /^I should not see a button called "([^\"]*)"$/ do |button|
  response.should_not have_selector("input[type='submit']", :value => button)
end

Then /^I should see a button called "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  response.should have_selector("#{parent} input[type='submit']", :value => button)
end

Then /^I should not see a button called "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  response.should_not have_selector("#{parent} input[type='submit']", :value => button)
end

Then /^(?:|I )press "([^\"]*)" within "([^\"]*)"$/ do |button, selector|
  within(selector) do |content|
    click_button(button)
  end
end

Then /^the DOM should have selector "([^\"]*)"$/ do |selector|
  response.should have_selector(selector)
end

Then /^the DOM should not have selector "([^\"]*)"$/ do |selector|
  response.should_not have_selector(selector)
end