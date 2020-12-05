#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $max = 0;
my @seats;

open INFILE, 'input.txt';
my $line;
while ($line = <INFILE>) {
    chomp($line);
    my $row = 0;
    my $column = 0;
    my $seat;
    my $row_def = substr($line, 0, 7);
    my $col_def = substr($line, 7, 9);
    foreach my $char (split //, $row_def) {
        $row = $row << 1;
        if ($char eq 'B') {
            $row = $row + 1;
        }
    }
    foreach my $char (split //, $col_def) {
        $column = $column << 1;
        if ($char eq 'R') {
            $column = $column + 1;
        }
    }
    $seat = ($row * 8) + $column;
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
