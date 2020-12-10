#!/usr/bin/env ruby

data = Array.new
data.push(0)

f = File.open("input.txt", "r")
f.each_line do |line|
  data.push(line.to_i)
end

data = data.sort
data.push(data.last + 3)

sums = { 1 => 0, 3 => 0 }
branches_at_node = { 0 => 1 }

for i in 0..data.length - 1
  this = data[i]
  if i > 0
    #               5
    #             5 - 6
    #               6              11
    # 0 - 1 - 4 -       - 7 - 10 -    - 12 - 15 - 16 - 19 - 22
    branches_at_node[this] = (branches_at_node[this - 1] || 0) + (branches_at_node[this - 2] || 0) + (branches_at_node[this - 3] || 0)
  end
  if i < data.length - 1
    diff = data[i + 1] - this
    sums[diff] += 1
  end
end

print "Part 1:  #{sums[1] * sums[3]}\n"
print "Part 2:  #{branches_at_node[data.last]}\n"