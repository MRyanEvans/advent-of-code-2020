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
  range[0] <= value && range[1] >= value
end

def value_matches_rule?(value, rule)
  value_in_range_inclusive?(value, rule[1]) || value_in_range_inclusive?(value, rule[2])
end

def value_matches_any_rule?(value, rules)
  rules.each do |rule|
    return true if value_matches_rule?(value, rule)
  end
  false
end

def value_matches_all_rules?(value, rules)
  rules.each do |rule|
    return false unless value_matches_rule?(value, rule)
  end
  true
end

def ticket_is_valid?(ticket, rules)
  ticket.each do |value|
    return false unless value_matches_any_rule?(value, rules)
  end
  true
end

def rules_matched_by_value(value, rules)
  matches = []
  rules.each do |rule|
    if value_matches_rule?(value, rule)
      matches << rule
    end
  end
  matches
end

def part1(rules, nearby_tickets)
  error_rate = 0
  nearby_tickets.each do |ticket|
    ticket.each do |val|
      error_rate += val unless value_matches_any_rule?(val, rules)
    end
  end
  error_rate
end

def part2(rules, nearby_tickets, my_ticket)
  valid_tickets = nearby_tickets.filter { |t| ticket_is_valid?(t, rules) }
  ticket_candidates = []
  valid_tickets.each do |ticket|
    candidates = {}
    ticket.each_with_index do |val, i|
      previous_matches = candidates.fetch(i, [])
      matched_rules = rules_matched_by_value(val, rules)
      matched_rules.each { |match|
        previous_matches << match[0]
      }
      candidates[i] = previous_matches.uniq
    end
    ticket_candidates << candidates
  end

  position_candidates = []
  (0..valid_tickets[0].size - 1).each do |pos|
    position_candidates << ticket_candidates.map { |t| t[pos] }.inject(&:&)
  end

  n = 0
  while true
    candidates = position_candidates[n]
    if candidates.size == 1
      position_candidates.each_with_index { |c, i|
        if i == n
          next
        end
        position_candidates[i] = position_candidates[i].filter { |d| d != candidates[0] }
      }
    end
    if position_candidates.map(&:size).max == 1
      break
    end
    n += 1
    if n == position_candidates.size
      n = 0
    end
  end
  order = position_candidates.flatten

  ticket_values = {}
  my_ticket.each_with_index do |v, i|
    v
    relative_field = order[i]
    ticket_values[relative_field] = v
  end
  ticket_values.filter { |v| v.start_with?('departure') }.map { |m| m[1] }.reduce(:*)
end

print "Part 1:  #{part1(rules, nearby_tickets)}\n"

print "Part 2:  #{part2(rules, nearby_tickets, my_ticket)}\n"
