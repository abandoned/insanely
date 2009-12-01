Then /^my query string should be "([^"]+)"$/ do |query_string|
  URI.parse(current_url).query.should == query_string
end
