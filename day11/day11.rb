#!/usr/bin/env ruby

def get_initial_map()
  map = Array.new
  f = File.open("input.txt", "r")
  $width = 0
  f.each_line do |line|
    map += line.strip.chars
    $width = line.strip.chars.length
  end
  map
end

def num_occupied (map)
  map.select { |item| item == "#" }.count
end

empty = 'L'
occupied = '#'

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

map = get_initial_map

loop do
  changed = false
  overlay = []
  for i in 0..map.length - 1
    num_occupied_adjacent = 0
    directions = [:diag_up_left, :up, :diag_up_right, :left, :right, :diag_down_left, :down, :diag_down_right]
    for d in directions
      si = get_seat_index_in_direction(i, d, map)
      if si == nil || si < 0
        next
      end
      if map[si] == occupied
        num_occupied_adjacent += 1
      end
    end

    this = map[i]

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

  map = overlay
  break if changed == false
end

print "Part 1:  #{num_occupied(map)}\n"

map = get_initial_map

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

  map = overlay
  break if changed == false
end

print "Part 2:  #{num_occupied(map)}\n"
