#!/usr/bin/env ruby

data = Array.new
f = File.open("input.txt", "r")
f.each_line do |line|
  data.push(line.to_i)
end

def some_of_slice_sums_to(sum, slice)
  for i in 0..slice.length() - 1
    for j in i..slice.length() - 1
      if slice[j] == sum - slice[i]
        return true
      end
    end
  end
  false
end

def find_contiguous (sum, data)
  for i in 0..data.length() - 1
    for j in i..data.length - 1
      until_end = data[i..j]
      if sum == until_end.inject(0, :+)
        return until_end.sort
      end
    end
  end
end

preamble_length = 25

for n in preamble_length..data.length() - 1
  unless some_of_slice_sums_to(data[n], data[n - preamble_length, preamble_length])
    part1 = data[n]
    break
  end
end

print "Part 1:  #{part1}\n"

contiguous = find_contiguous(part1, data)

part2 = contiguous.first + contiguous.last

print "Part 2:  #{part2}\n"
