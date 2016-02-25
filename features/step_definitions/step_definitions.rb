require "fileutils"
require "colorize"

Given(/^I have a directory with measurements from a communal drive at `(.*)`$/) do |dir|
  @meas_dir = dir
  FileUtils.rm_rf(dir)
  FileUtils.mkdir_p(dir)
end

Given(/^in that directory, I have a file `(.*)`$/) do |file|
  FileUtils.mkdir_p(File.dirname(File.join(@meas_dir, file)))
  FileUtils.touch(File.join(@meas_dir, file))
end

Given(/^in that directory, I have a config file with the following content$/) do |string|
  File.write(File.join(@meas_dir, "config.json"), string)
end

When(/^I type `(.*)`$/) do |command|
  @output = `#{command} 2>&1`.uncolorize
end

When(/^the results folder is `(.*)`$/) do |dir|
  @results_dir = dir
end

Then(/^I want to see the file `(.*)` in the results folder$/) do |file|
  expect(File).to exist(File.join(@results_dir, file))
end
