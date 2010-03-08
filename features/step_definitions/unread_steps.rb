Then /^there should be unread content$/ do
  response.should have_selector('.circle')
end

Then /^there should be no unread content$/ do
  response.should_not have_selector('.circle')
end
