#!/usr/bin/env ruby

instructions = Array.new
File.open("input.txt", "r").each_line do |line|
  split = line.strip.split(/([A-Z])([0-9]+)/)
  instructions.push([split[1], split[2].to_i])
end

def move_by_angle(point, angle, distance)
  case angle % 360
  when 0
    return [point[0] + distance, point[1]]
  when 90
    return [point[0], point[1] + distance]
  when 180
    return [point[0] - distance, point[1]]
  when 270
    return [point[0], point[1] - distance]
  end
end

def part1(data)
  ship = [0, 0]
  ang = 90
  data.each do |instr|
    case instr.first
    when 'F'
      ship = move_by_angle(ship, ang, instr.last)
    when 'N'
      ship = move_by_angle(ship, 0, instr.last)
    when 'S'
      ship = move_by_angle(ship, 180, instr.last)
    when 'E'
      ship = move_by_angle(ship, 90, instr.last)
    when 'W'
      ship = move_by_angle(ship, 270, instr.last)
    when 'R'
      ang = (ang + instr.last) % 360
    when 'L'
      ang = (ang - instr.last) % 360
    end
  end

  ship[0].abs + ship[1].abs
end

def turn_point (point, angle)
  case angle % 360
  when 90
    [-point[1], point[0]]
  when 180
    [-point[0], -point[1]]
  when 270
    [point[1], -point[0]]
  end
end

def part2(data)
  ship = [0, 0]
  waypoint = [1, 10]
  data.each do |instr|
    case instr.first
    when 'F'
      ship[0] += waypoint[0] * instr.last
      ship[1] += waypoint[1] * instr.last
    when 'N'
      waypoint[0] += instr.last
    when 'S'
      waypoint[0] -= instr.last
    when 'E'
      waypoint[1] += instr.last
    when 'W'
      waypoint[1] -= instr.last
    when 'R'
      waypoint = turn_point(waypoint, instr.last)
    when 'L'
      waypoint = turn_point(waypoint, 360 - instr.last)
    end
  end

  ship[0].abs + ship[1].abs
end

print "Part 1:  #{part1(instructions)}\n"

print "Part 2:  #{part2(instructions)}\n"
