#!/usr/bin/env ruby

input = []
f = File.open('input.txt', 'r')
f.each_line do |line|
  mask_match = line.strip.split(/mask\s=\s(([01X])+)/)
  mem_match = line.strip.split(/mem\[([0-9]+)\]\s=\s([0-9]+)/)
  input << [:mask, mask_match[1]] if mask_match.count > 1
  input << [:mem, mem_match[1].to_i, mem_match[2].to_i] if mem_match.count > 1
end

def part1(values)
  addresses = {}
  one_mask = nil
  zero_mask = nil

  values.each do |v|
    if v[0] == :mask
      one_mask = v[1].gsub('X', '0')
      zero_mask = v[1].gsub('X', '1')
      next
    end
    addresses[v[1]] = (v[2] | one_mask.to_i(2)) & zero_mask.to_i(2)
  end
  addresses.values.inject(:+)
end

def generate_addresses(masked_address)
  indexes = []
  addresses = []
  masked_address.clone.chars.each_with_index do |c, index|
    indexes << index if c == 'X'
  end
  value_combs = %w[0 1].cycle(indexes.size).to_a.combination(indexes.size).uniq
  position_combs = indexes.combination(indexes.size).cycle(value_combs.size).to_a

  position_combs.zip(value_combs).each do |p, v|
    temp_address = masked_address.clone
    (0..temp_address.length - 1).each do |i|
      temp_address[i] = v[p.index(i)] if p.include? i
    end
    addresses << temp_address.to_i(2)
  end
  addresses
end

def part2(values)
  addresses = {}
  mask = nil
  values.each do |v|
    if v[0] == :mask
      mask = v[1].to_s.clone
      next
    end

    mask_overlayed_on_address = v[1].to_s(2)
                                    .rjust(mask.length, '0')
                                    .chars
                                    .zip(mask.chars)
                                    .map { |address_char, mask_char| mask_char == '0' ? address_char : mask_char }
                                    .join
    all_addresses = generate_addresses(mask_overlayed_on_address)
    all_addresses.each { |a| addresses[a] = v[2] }
  end
  addresses.values.inject(:+)
end

print "Part 1:  #{part1(input)}\n"

print "Part 2:  #{part2(input)}\n"
