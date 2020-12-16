#!/usr/bin/env ruby

state = :rules
rules = []
my_ticket = []
nearby_tickets = []

File.open('input.txt', 'r').each_line do |l|
  case l.strip
  when '' then
    next
  when 'your ticket:' then
    state = :my_ticket
    next
  when 'nearby tickets:' then
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
  rules.any? { |rule| value_matches_rule?(value, rule) }
end

def part1(rules, nearby_tickets)
  nearby_tickets.map { |t| t.filter { |val| !value_matches_any_rule?(val, rules) }.reduce(0, &:+) }.reduce(&:+)
end

def get_candidates_for_ticket(ticket, rules)
  candidates = {}
  ticket.each_with_index do |val, i|
    previous_matches = candidates.fetch(i, [])
    rules.filter { |rule| value_matches_rule?(val, rule) }.each { |match| previous_matches << match[0] }
    candidates[i] = previous_matches
  end
  candidates
end

def part2(rules, nearby_tickets, my_ticket)
  valid_tickets = nearby_tickets.filter { |t| t.all? { |v| value_matches_any_rule?(v, rules) } }
  ticket_candidates = valid_tickets.map { |ticket| get_candidates_for_ticket(ticket, rules) }

  position_candidates = []
  (0..valid_tickets[0].size - 1).each do |pos|
    # get the candidates for position from each ticket and apply the & operator to find rules common in all positions
    position_candidates << ticket_candidates.map { |t| t[pos] }.inject(&:&)
  end

  n = 0
  loop do
    candidates = position_candidates[n]
    if candidates.size == 1
      # narrowed down only one possible candidate for position
      position_candidates.each_index do |i|
        next if i == n
        # remove candidate from other lists as we know it can't go there anymore
        position_candidates[i] = position_candidates[i].filter { |d| d != candidates.first }
      end
    end
    # end when everything has exactly one candidate
    break if position_candidates.map(&:size).max == 1

    n += 1
    n = 0 if n == position_candidates.size
  end

  my_ticket.each_with_index.map { |v, i| [position_candidates.flatten[i], v] }
           .to_h
           .filter { |v| v.start_with?('departure') }
           .map { |m| m[1] }
           .reduce(:*)
end

print "Part 1:  #{part1(rules, nearby_tickets)}\n"

print "Part 2:  #{part2(rules, nearby_tickets, my_ticket)}\n"
