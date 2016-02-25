require "fileutils"
require "colorize"

Given(/^I have a directory `(.*)` with the following files$/) do |dir, files|
  @meas_dir = dir
  FileUtils.rm_rf(dir)
  FileUtils.mkdir_p(dir)
  files.lines.map(&:chomp).each do |file|
    FileUtils.mkdir_p(File.dirname(File.join(@meas_dir, file)))
    FileUtils.touch(File.join(@meas_dir, file))
  end
end

Given(/^I have a config file at `(.*)` with the following content$/) do |filename, string|
  File.write(filename, string)
end

When(/^I type `(.*)`$/) do |command|
  @output = `#{command} 2>&1`.uncolorize
  puts @output
end

Then(/^I want to see the following files in `(.*)`$/) do |results_dir, files|
  files.lines.map(&:chomp).each do |file|
    expect(File).to exist(File.join(results_dir, file))
  end
end
