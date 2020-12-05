#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my @seats;
open INFILE, 'input.txt';
while (my $line = <INFILE>) {
    chomp($line);
    my $seat = 0;
    foreach my $char (split //, $line) {
        $seat = $seat << 1;
        if ($char eq 'B' || $char eq 'R') {
            $seat++;
        }
    }
    push @seats, $seat;
}
close INFILE;

@seats = sort {$a <=> $b} @seats;
print "Part 1:  " . $seats[-1] . "\n";
for my $i (0 .. ($#seats - 1)) {
    my $expected_next = $seats[$i] + 1;
    if ($seats[$i + 1] != $expected_next) {
        print "Part 2:  " . $expected_next . "\n";
    }
}
