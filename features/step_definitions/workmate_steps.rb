Then /^(\w) should have ([0-9]+) workmate$/ do |login, count|
  if login == 'I'
    user = current_user
  else
    user = User.find_by_login(login)
  end
  user.workmates.size should == count.to_i
end