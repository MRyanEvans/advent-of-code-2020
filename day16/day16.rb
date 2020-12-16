#!/usr/bin/env ruby

state = :rules
rules = []
my_ticket = []
nearby_tickets = []

File.open('input.txt', 'r').each_line do |l|
  next if l.strip == ''

  if l.strip == 'your ticket:'
    state = :my_ticket
    next
  end
  if l.strip == 'nearby tickets:'
    state = :nearby_tickets
    next
  end
  if state == :rules
    match = l.strip.split(/(.+):\s((\d+)-(\d+))\sor\s((\d+)-(\d+))/)
    rules << [match[1], [match[3].to_i, match[4].to_i], [match[6].to_i, match[7].to_i]]
  end
  my_ticket = l.strip.split(',').map(&:to_i) if state == :my_ticket
  nearby_tickets << l.strip.split(',').map(&:to_i) if state == :nearby_tickets
end

def value_in_range_inclusive?(value, range)
  if range[0] <= value && range[1] >= value
    return true
  end
  false
end

def value_matches_rule?(value, rule)
  if value_in_range_inclusive?(value, rule[1]) || value_in_range_inclusive?(value, rule[2])
    return true
  end
  false
end

def value_matches_any_rule?(value, rules)
  rules.each { |rule|
    if value_matches_rule?(value, rule)
      return true
    end
  }
  false
end

def part1(rules, nearby_tickets)
  error_rate = 0
  nearby_tickets.each { |ticket|
    ticket.each do |val|
      unless value_matches_any_rule?(val, rules)
        error_rate += val
      end
    end
  }
  error_rate
end

def part2
end

print "Part 1:  #{part1(rules, nearby_tickets)}\n"

print "Part 2:  #{part2}\n"
