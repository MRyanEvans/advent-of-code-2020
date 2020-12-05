#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $max = 0;
my @seats;

open INFILE, 'input.txt';
my $line;
while ($line = <INFILE>) {
    chomp($line);
    my $seat = 0;
    foreach my $char (split //, $line) {
        $seat = $seat << 1;
        if ($char eq 'B' || $char eq 'R') {
            $seat = $seat + 1;
        }
    }
    if ($seat > $max) {
        $max = $seat;
    }
    push @seats, $seat;
}
close INFILE;

print "Part 1:  " . $max . "\n";

@seats = sort {$a <=> $b} @seats;

for my $i (0 .. $#seats) {
    if (!exists($seats[$i + 1])) {
        last; # we know it's not at the back
    }
    my $next = $seats[$i + 1];
    my $expected_next = $seats[$i] + 1;
    if ($next != $expected_next) {
        print "Part 2:  " . $expected_next . "\n";
    }
}
