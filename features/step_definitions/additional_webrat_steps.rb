Then /^my query string should be "([^"]+)"$/ do |query_string|
  URI.parse(current_url).query.should == query_string
end

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

Then /^the field with id "([^\"]*)" should contain "([^\"]*)"$/ do |id, value|
  field_with_id(id).should contain(value)
end