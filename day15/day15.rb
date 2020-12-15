#!/usr/bin/env ruby

starting_numbers = File.open('input.txt', 'r').first.strip.split(",").map(&:to_i)

def play(starting_numbers, limit)
  last = []
  before_last = []

  t = 0
  num = nil
  starting_numbers.each do |s|
    last[s] = t
    num = s
    t += 1
  end

  while t < limit
    last_spoken = last[num]
    last_spoken_before_then = before_last[num]
    num = if last_spoken.nil? || last_spoken_before_then.nil?
            0
          else
            last_spoken - last_spoken_before_then
          end
    before_last[num] = last[num]
    last[num] = t
    t += 1
  end
  num
end

print "Part 1:  #{play(starting_numbers, 2020)}\n"

print "Part 2:  #{play(starting_numbers, 30_000_000)}\n"
