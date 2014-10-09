#!/usr/bin/ruby
fn = ARGV[0] || 'example.txt'
defaultunit = 'JPY'
data = File.open(fn, 'r'){|fd|fd.read}
accounts = {}
data.split("\n").each do |line|
  next if /^#/ === line
  next if line.empty?
  date, from, amount, to, comment, exchange = line.split(",").map{|v|v.strip}
  amount = amount.to_f
  accounts[from] ||= 0.0
  accounts[from] -= amount
  accounts[to] ||= 0.0
  accounts[to] += amount
end
puts "Assets"
accounts.each do |a, b|
  next if /^_/ === a
  next if b < 0
  puts "* #{a} #{b}"
end
puts
puts "Liabilities"
accounts.each do |a, b|
  next if /^_/ === a
  next if b >= 0
  puts "* #{a} #{-b}"
end
puts
puts "Equity"
accounts.each do |a, b|
  next unless /^_/ === a
  next if b == 0
  puts "* #{a} #{-b}"
end
