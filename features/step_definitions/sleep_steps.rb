Given /^([0-9\.]+) seconds? (?:has|have) elapsed$/ do |interval|
  sleep(interval.to_f)
end