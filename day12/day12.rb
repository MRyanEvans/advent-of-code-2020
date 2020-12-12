#!/usr/bin/env ruby

data = Array.new
f = File.open("input.txt", "r")
$width = 0
f.each_line do |line|
  split = line.strip.split(/([A-Z])([0-9]+)/)
  data.push([split[1], split[2].to_i])
end

def part1(data)
  vectors = []
  ang = 90
  for instr in data
    case instr.first
    when 'F'
      vectors.push([ang, instr.last])
    when 'N'
      vectors.push([0, instr.last])
    when 'S'
      vectors.push([180, instr.last])
    when 'E'
      vectors.push([90, instr.last])
    when 'W'
      vectors.push([270, instr.last])
    when 'R'
      ang  = (ang + instr.last ) % 360
   when 'L'
      ang  = (ang - instr.last ) % 360
    end
  end

  north = 0
  south = 0
  east = 0
  west = 0
  for v in vectors
    print "#{v}\n"
    case v.first
    when 0
      north += v.last
    when 90
      east += v.last
    when 180
      south += v.last
    when 270
      west += v.last
    end
  end
  return (north - south).abs + (east - west).abs
end

print "Part 1:  #{part1(data)}\n"
