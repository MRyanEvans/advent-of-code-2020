#!/usr/bin/env ruby

cubes = {}
y = 0
z = 0
w = 0
File.open('input.txt', 'r').each_line do |l|
  x = 0
  for c in l.strip.chars
    if c == '#'
      cubes[[x, y, z, w]] = :active
    else
      cubes[[x, y, z, w]] = :inactive
    end
    x += 1
  end
  y += 1
end

def expand(cubes)
  expanded = {}
  max_x = cubes.map { |c| c[0][0] }.sort.last
  max_y = cubes.map { |c| c[0][1] }.sort.last
  max_z = cubes.map { |c| c[0][2] }.sort.last
  max_w = cubes.map { |c| c[0][3] }.sort.last
  for w in (-max_w - 1)..max_w + 1
    for z in (-max_z - 1)..max_z + 1
      for y in 0..max_y + 1
        for x in 0..max_x + 1
          if x == max_x + 1 || y == max_y + 1
            expanded[[x + 1, y + 1, z, w]] = :inactive
          elsif x == 0 || y == 0
            expanded[[x, y, z, w]] = :inactive
            expanded[[x + 1, y + 1, z, w]] = cubes[[x, y, z, w]]
          else
            if cubes[[x, y, z, w]] == nil
              expanded[[x + 1, y + 1, z, w]] = :inactive
            else
              expanded[[x + 1, y + 1, z, w]] = cubes[[x, y, z, w]]
            end
          end
        end
      end
    end
  end
  expanded
end

def cycle(cubes)
  new_layer = {}
  for cube in cubes
    x, y, z, w = cube[0]
    neighbours = get_neighbour_coordinates(x, y, z, w)
    active_neighbours = neighbours.map { |n| cubes[[n[0], n[1], n[2], n[3]]] }.filter { |v| v == :active }
    if cube[1] == :active
      if active_neighbours.count == 2 || active_neighbours.count == 3
        new_layer[[x, y, z, w]] = :active
      else
        new_layer[[x, y, z, w]] = :inactive
      end
    else
      if active_neighbours.count == 3
        new_layer[[x, y, z, w]] = :active
      else
        new_layer[[x, y, z, w]] = :inactive
      end
    end
  end
  new_layer
end

def print_layer(cubes, z)
  max_x = cubes.filter { |c| c[2] == z }.map { |c| c[0][0] }.sort.last
  max_y = cubes.filter { |c| c[2] == z }.map { |c| c[0][1] }.sort.last
  buffer = ''
  buffer += "z=#{z}\n"
  for y in 0..max_y
    for x in 0..max_x
      c = cubes[[x, y, z]]
      if c == :active
        char = '#'
      else
        char = '.'
      end
      buffer << char
      if x == max_x
        buffer += "\n"
      end
    end
  end
  print buffer += "\n"
end

$permut_cache = [-1, 0, 1].cycle(4).to_a.permutation(4).uniq

def get_neighbour_coordinates(x, y, z, w)
  $permut_cache.map { |c| [c[0] + x, c[1] + y, c[2] + z, c[3] + w] }.filter { |c| c != [x, y, z, w] }
end

for n in 0..5
  expanded = expand(cubes)
  cycled_cubes = cycle(expanded)
  count = cycled_cubes.count
  count_active = cycled_cubes.values.filter { |c| c == :active }.count
  print "N:  #{n}, Count:  #{count}, Active:  #{count_active}\n"
  cubes = cycled_cubes
end