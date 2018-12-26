#! /usr/bin/env ruby

require 'nokogiri'

filename = File.expand_path(ARGV[0])
html = ""

File.open(filename) do |f|
  f.readlines.each do |line|
    if line.chomp.start_with? ('<p><strong>Draft</strong>')
      html = line
      break
    end
  end
end

text = Nokogiri::HTML(html).text.chomp
if text.empty?
  puts "\t\t\t"
else
  begin
    team = text.match(/^(Draft:)?\s*([\w\s\.]*)/)[2]
    round = text.match(/(\d+)\w\w.*round/)[1]
    overall = text.match(/\((\d+)\w\w.*overall/)[1]
    year = text.match(/(\d\d\d\d).*NHL/)[1]
    puts "#{year}\t#{round}\t#{overall}\t#{team}"
  rescue
    warn "FAIL: #{filename}"
    puts "\t\t\t"
  end
end
