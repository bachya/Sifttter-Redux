When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} --help`)
end

Given(/^no file located at "(.*?)"$/) do |filepath|
  expect(File).to_not exist(File.expand_path(filepath))
end