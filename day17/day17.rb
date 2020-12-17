#!/usr/bin/env ruby

cubes = {}
y = 0
z = 0
w = 0
File.open('input.txt', 'r').each_line do |l|
  x = 0
  l.strip.chars.each do |c|
    cubes[[x, y, z, w]] = if c == '#'
                            :active
                          else
                            :inactive
                          end
    x += 1
  end
  y += 1
end

def expand(cubes)
  expanded = {}
  max_x = cubes.map { |c| c[0][0] }.max
  max_y = cubes.map { |c| c[0][1] }.max
  max_z = cubes.map { |c| c[0][2] }.max
  max_w = cubes.map { |c| c[0][3] }.max
  ((-max_w - 1)..max_w + 1).each do |w|
    ((-max_z - 1)..max_z + 1).each do |z|
      (0..max_y + 1).each do |y|
        (0..max_x + 1).each do |x|
          if x == max_x + 1 || y == max_y + 1
            expanded[[x + 1, y + 1, z, w]] = :inactive
          elsif x.zero? || y.zero?
            expanded[[x, y, z, w]] = :inactive
            expanded[[x + 1, y + 1, z, w]] = cubes[[x, y, z, w]]
          else
            expanded[[x + 1, y + 1, z, w]] = if cubes[[x, y, z, w]] == nil
                                               :inactive
                                             else
                                               cubes[[x, y, z, w]]
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
  cubes.each do |cube|
    x, y, z, w = cube[0]
    neighbours = get_neighbour_coordinates(x, y, z, w)
    active_neighbours = neighbours.map { |n| cubes[[n[0], n[1], n[2], n[3]]] }.filter { |v| v == :active }
    new_layer[[x, y, z, w]] = if cube[1] == :active
                                if active_neighbours.count == 2 || active_neighbours.count == 3
                                  :active
                                else
                                  :inactive
                                end
                              elsif active_neighbours.count == 3
                                :active
                              else
                                :inactive
                              end
  end
  new_layer
end

def print_layer(cubes, z)
  max_x = cubes.filter { |c| c[2] == z }.map { |c| c[0][0] }.sort.last
  max_y = cubes.filter { |c| c[2] == z }.map { |c| c[0][1] }.sort.last
  buffer = ''
  buffer += "z=#{z}\n"
  (0..max_y).each do |y|
    (0..max_x).each do |x|
      c = cubes[[x, y, z]]
      char = if c == :active
               '#'
             else
               '.'
             end
      buffer << char
      buffer += "\n" if x == max_x
    end
  end
  print buffer += "\n"
end

$permut_cache = [-1, 0, 1].cycle(4).to_a.permutation(4).uniq

def get_neighbour_coordinates(x, y, z, w)
  $permut_cache.map { |c| [c[0] + x, c[1] + y, c[2] + z, c[3] + w] }.filter { |c| c != [x, y, z, w] }
end

(0..5).each do |n|
  expanded = expand(cubes)
  cycled_cubes = cycle(expanded)
  count = cycled_cubes.count
  count_active = cycled_cubes.values.filter { |c| c == :active }.count
  print "N:  #{n}, Count:  #{count}, Active:  #{count_active}\n"
  cubes = cycled_cubes
end
