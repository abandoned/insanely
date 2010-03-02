Given /^#{capture_model} is (.+)$/ do |name, status|
  model(name).update_attribute(:status, status)
end