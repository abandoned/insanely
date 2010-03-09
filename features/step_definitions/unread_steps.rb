Then /^there should be unread content$/ do
  response.should have_selector('.unread')
end

Then /^there should be no unread content$/ do
  response.should_not have_selector('.unread')
end
