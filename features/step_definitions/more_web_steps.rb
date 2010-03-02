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

Then /^the (?:html|HTML) should contain "([^\"]*)"$/ do |text|
  response.should contain(text)
end

Then /^the (?:html|HTML) should not contain "([^\"]*)"$/ do |text|
  response.should_not contain(text)
end

Then /^the (?:html|HTML) should contain "([^\"]*)" within "([^\"]*)"$/ do |text, selector|
  within(selector) do |content|
    content.should have_selector(text)
  end
end

Then /^the (?:html|HTML) should not contain "([^\"]*)" within "([^\"]*)"$/ do |text, selector|
  within(selector) do |content|
    content.should_not have_selector(text)
  end
end