#! /usr/bin/env ruby

require 'nokogiri'

filename = File.expand_path(ARGV[0])
html = ""

File.open(filename) do |f|
  f.readlines.each do |line|
    html << line
  end
end

doc = Nokogiri::HTML(html)
doc.xpath('//comment()').each { |comment| comment.replace(comment.text) } #removes comment tags and exposes contents as html

all_arrs = []

doc.search('table').each do |table|
  arr = []
  table.search('tr').each do |row|
    cells = row.search('th, td').map { |cell| cell.text.strip }
    arr << cells
  end
  all_arrs << arr
end


all_arrs.each do |arr|
  arr.each do |row|
    puts row.join("\t")
  end
  puts "\n\n\n"
end
