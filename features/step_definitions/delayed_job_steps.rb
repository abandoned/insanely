Then /^([0-9]+) messages? should be queued for notification$/ do |count|
  Delayed::Job.count.should == count.to_i
end