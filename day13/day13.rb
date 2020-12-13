#!/usr/bin/env ruby

f = File.open("input.txt", "r")
target_time = f.first.strip.to_i
buses = f.first.strip.split(",").map { |t|
  if t != "x"
    t.to_i
  else
    t
  end
}

def part1(target, buses)
  min = buses.select { |b| b.is_a? Numeric }
             .map { |bus|
               offset = target % bus
               first_after = target + (bus - offset)
               [first_after, bus]
             }.to_h.min
  wait = min[0] - target
  min[1] * wait
end


def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient * x, x
    y, last_y = last_y - quotient * y, y
  end
  last_x * (a.negative? ? -1 : 1)
end

def part2(buses)
  remainders = []
  buses.each_with_index do |bus, index|
    if bus != "x"
      remainders.push(index * -1)
    end
  end

  mods = buses.select { |b| b.is_a? Numeric }
  prod = mods.inject(:*)
  series = remainders.zip(mods).map { |r, m| (r * prod * (extended_gcd(prod / m, m) % m) / m) }
  series.sum % prod
end

print "Part 1:  #{part1(target_time, buses)}\n"

print "Part 2:  #{part2(buses)}\n"
