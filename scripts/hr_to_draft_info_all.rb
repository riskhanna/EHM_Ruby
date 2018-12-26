#! /usr/bin/env ruby

ASSET_PATH = File.expand_path File.join(File.dirname(__FILE__), "../assets/Html/*.html")
SCRIPT_NAME = "hr_to_draft_info.rb"

files = `find #{ASSET_PATH}`.split

files.sort_by! {|file| file.match(/\d\d\d\d/)[0].to_i}

files.each do |file|
  puts `ruby #{SCRIPT_NAME} #{file}`
end
