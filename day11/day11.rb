#!/usr/bin/env ruby

map = Array.new
f = File.open("input.txt", "r")
$width = 0
f.each_line do |line|
  map += line.strip.chars
  $width = line.strip.chars.length
end

width = $width # todo sort out

def print_map (map, width)
  for i in (0..map.length - 1).step(width)
    line = map[i, width] * ""
    print "#{line}\n"
  end
  print "\n"
end

def num_occupied (map)
  map.select { |item| item == "#" }.count
end

empty = 'L'
occupied = '#'
floor = '.'

changed = false

def get_adjacent(n, map)
  if n < 0
    return nil
  end
  map[n]
end

def get_absolute(n, map)
  if n == nil || n  < 0
    return nil
  end
  map[n]
end

def get_seat_in_direction(i, dir, map)
  return get_absolute(get_seat_index_in_direction(i, dir, map), map)
end

def get_seat_index_in_direction(i, dir, map)
  if dir == :up
    if i - $width < 0
      return nil
    end
    return i - $width
  end
  if dir == :diag_up_left
    if i - $width < 0 || i % $width == 0
      return nil
    end
    return i - $width - 1
  end
  if dir == :diag_up_right
    if i - $width < 0 || i % $width == $width - 1
      return nil
    end
    return (i - $width) + 1
  end
  if dir == :left
    if i % $width == 0
      return nil
    end
    return i - 1
  end
  if dir == :right
    if i % $width == $width - 1
      return nil
    end
    return i + 1
  end
  if dir == :diag_down_left
    if i + $width > map.length - 1 || i % $width == 0
      return nil
    end
    return (i + $width) - 1
  end
  if dir == :diag_down_right
    if i + $width > map.length - 1 || i % $width == $width - 1
      return nil
    end
    return i + $width + 1
  end
  if dir == :down
    if i + $width > map.length - 1
      return nil
    end
    return i + $width
  end
  nil
end

loop do
  changed = false
  overlay = []
  for i in 0..map.length - 1
    adjacent = [get_seat_in_direction(i, :diag_up_left, map), get_seat_in_direction(i, :up, map), get_seat_in_direction(i, :diag_up_right, map),
                get_seat_in_direction(i, :left, map), get_seat_in_direction(i, :right, map),
                get_seat_in_direction(i, :diag_down_left, map), get_seat_in_direction(i, :down, map), get_seat_in_direction(i, :diag_down_right, map)
    ]
    this = map[i]
    num_occupied_adjacent = 0
    for s in adjacent
      if s == occupied
        num_occupied_adjacent += 1
      end
    end

    if this == empty && num_occupied_adjacent == 0
      overlay[i] = occupied
      changed = true
    elsif this == occupied && num_occupied_adjacent >= 4
      overlay[i] = empty
      changed = true
    else
      overlay[i] = this
    end

  end

  # print_map(overlay, width)
  map = overlay
  break if changed == false
end

print "Part 1:  #{num_occupied(map)}\n"

map = Array.new
f = File.open("input.txt", "r")
f.each_line do |line|
  map += line.strip.chars
  $width = line.strip.chars.length
end

loop do
  changed = false
  overlay = []
  for i in 0..map.length - 1
    this = map[i]
    num_occupied_adjacent = 0
    directions = [:diag_up_left, :up, :diag_up_right, :left, :right, :diag_down_left, :down, :diag_down_right]
    for dir in directions
      n = i
      loop do
        adjacent_index = get_seat_index_in_direction(n, dir, map)
        break if adjacent_index == nil
        if map[adjacent_index] == occupied
          num_occupied_adjacent += 1
          break
        elsif map[adjacent_index] == empty
          break
        end
        n = adjacent_index
      end

    end

    if this == empty && num_occupied_adjacent == 0
      overlay[i] = occupied
      changed = true
    elsif this == occupied && num_occupied_adjacent >= 5
      overlay[i] = empty
      changed = true
    else
      overlay[i] = this
    end
  end

  # print_map(overlay, width)
  map = overlay
  break if changed == false
end

print "Part 2:  #{num_occupied(map)}\n"
